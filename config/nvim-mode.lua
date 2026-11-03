--[[
    Neovim 风格窗格操作（smart-splits）——当前默认关闭

    为什么默认关闭：
      WezTerm 一旦绑定 Ctrl+h/j/k/l，就会在按键到达终端之前把事件截走；
      nvim 的 <C-h>（切到 NvimTree 等）只有在 WezTerm 判断出「这个窗格
      是 nvim」并主动透传时才生效。IS_NVIM 用户变量缺失/时机不对时，
      按键就会失效。为了保证 nvim 内部键位完全不受影响，默认不接管，
      只保留 LEADER + v 的 nvim_mode 键层。

    想启用（例如确认 nvim 端 IS_NVIM 正常后）：
      把下面的 M.enable_smart_splits 改成 true。
      启用后优先用 official 插件；插件不可用时自动回退到同款内置实现。
]]

local wezterm = require('wezterm')
local act = wezterm.action

local M = {}

M.PLUGIN_URL = 'https://github.com/mrjones2014/smart-splits.nvim'

-- 是否尝试从 GitHub 拉取插件。离线环境下首次加载会等待 git 超时（约 20s），
-- 只有内置实现时可以把这里改成 false，加载会瞬间完成。
M.try_plugin = true

-- ⚠ 是否让 WezTerm 接管 Ctrl / Alt + h/j/k/l。
-- 默认 false：不拦截这些键，按键原样送进终端，nvim 的 <C-h> 能正常切到 NvimTree。
-- 改成 true 才会启用 smart-splits（需要 nvim 端正确写入 IS_NVIM 用户变量）。
M.enable_smart_splits = true

-- Ctrl + h/j/k/l 移动焦点。
-- 注意：会抢占 shell 的 Ctrl+L(清屏)/Ctrl+K(删到行尾)/Ctrl+J/Ctrl+H(退格)，
-- 如果更在意 shell 体验，可改成 'CTRL|SHIFT'（即 Ctrl+Shift+h/j/k/l）。
M.move_mods = 'CTRL'
-- Alt(META) + h/j/k/l 调整窗格大小
M.resize_mods = 'ALT'

---方向键 -> WezTerm 方向名，顺序即绑定顺序
---@type table<integer, { [1]: string, [2]: string }>
M.directions = {
	{ 'h', 'Left' },
	{ 'j', 'Down' },
	{ 'k', 'Up' },
	{ 'l', 'Right' },
}

---当前窗格是否运行着 Neovim（由 nvim 端 smart-splits.nvim 设置 IS_NVIM 用户变量）
---@param pane any
---@return boolean
local function is_vim(pane)
	local ok, vars = pcall(function()
		return pane:get_user_vars()
	end)
	if ok and type(vars) == 'table' and (vars.IS_NVIM == 'true' or vars.IS_NVIM == '1') then
		return true
	end

	-- 兜底：nvim 未写入 IS_NVIM 时，按前台进程名判断，避免按键被 WezTerm 吃掉
	local ok2, proc = pcall(function()
		return pane:get_foreground_process_name()
	end)
	if not ok2 or type(proc) ~= 'string' then
		return false
	end
	local name = (proc:match('([^/\\]+)$') or proc):gsub('%.exe$', ''):lower()
	return name == 'nvim' or name == 'nvim-qt' or name == 'vim'
end
M.is_vim = is_vim

---@param direction string
---@param key string
---@param mods string
---@return table
local function move_action(direction, key, mods)
	return wezterm.action_callback(function(window, pane)
		if is_vim(pane) then
			window:perform_action(act.SendKey({ key = key, mods = mods }), pane)
		else
			window:perform_action(act.ActivatePaneDirection(direction), pane)
		end
	end)
end

---@param direction string
---@param key string
---@param mods string
---@return table
local function resize_action(direction, key, mods)
	return wezterm.action_callback(function(window, pane)
		if is_vim(pane) then
			window:perform_action(act.SendKey({ key = key, mods = mods }), pane)
		else
			window:perform_action(act.AdjustPaneSize({ direction, 1 }), pane)
		end
	end)
end

---内置实现（插件缺失时的兜底）
---@return table[]
function M.build_builtin_keys()
	local keys = {}
	for _, d in ipairs(M.directions) do
		local key, direction = d[1], d[2]
		table.insert(keys, {
			key = key,
			mods = M.move_mods,
			action = move_action(direction, key, M.move_mods),
		})
		table.insert(keys, {
			key = key,
			mods = M.resize_mods,
			action = resize_action(direction, key, M.resize_mods),
		})
	end
	return keys
end

---尝试加载官方插件；成功返回它生成的 keys，失败返回 nil + 原因
---@return table[]|nil, string|nil
function M.load_plugin_keys()
	if not wezterm.plugin or type(wezterm.plugin.require) ~= 'function' then
		return nil, 'this wezterm build has no plugin manager'
	end

	local ok, plugin = pcall(wezterm.plugin.require, M.PLUGIN_URL)
	if not ok then
		return nil, tostring(plugin)
	end
	if type(plugin) ~= 'table' or type(plugin.apply_to_config) ~= 'function' then
		return nil, 'plugin loaded but has no apply_to_config()'
	end

	-- 借一个临时 table 收集插件生成的 keys，再并回本配置的 keys 数组，
	-- 避免出现两份 config.keys 互相覆盖。
	local scratch = { keys = {} }
	local ok2, err = pcall(plugin.apply_to_config, scratch, {
		direction_keys = { 'h', 'j', 'k', 'l' },
		modifiers = { move = M.move_mods, resize = M.resize_mods },
		is_vim = is_vim,
	})
	if not ok2 then
		return nil, tostring(err)
	end
	return scratch.keys, nil
end

---解析最终要用的分屏快捷键
---@return table[] keys
---@return string backend 'plugin' | 'builtin'
function M.resolve_keys()
	if not M.enable_smart_splits then
		return {}, 'disabled'
	end

	local plugin_keys, err
	if M.try_plugin then
		plugin_keys, err = M.load_plugin_keys()
	else
		err = 'disabled by M.try_plugin = false'
	end
	if plugin_keys and #plugin_keys > 0 then
		return plugin_keys, 'plugin'
	end

	wezterm.log_warn(
		'smart-splits.nvim WezTerm 插件不可用，已回退到内置实现：' .. tostring(err)
	)
	return M.build_builtin_keys(), 'builtin'
end

M.key_tables = {
	-- LEADER + v 进入的「Normal 模式」键盘层：hjkl 导航，Esc/q 退出
	-- （与 nvim 无关，任何时候都不会抢占 Ctrl+h/j/k/l）
	nvim_mode = {
		{ key = 'h',      mods = 'NONE',  action = act.ActivatePaneDirection('Left') },
		{ key = 'j',      mods = 'NONE',  action = act.ActivatePaneDirection('Down') },
		{ key = 'k',      mods = 'NONE',  action = act.ActivatePaneDirection('Up') },
		{ key = 'l',      mods = 'NONE',  action = act.ActivatePaneDirection('Right') },
		{ key = 'H',      mods = 'SHIFT', action = act.AdjustPaneSize({ 'Left', 1 }) },
		{ key = 'J',      mods = 'SHIFT', action = act.AdjustPaneSize({ 'Down', 1 }) },
		{ key = 'K',      mods = 'SHIFT', action = act.AdjustPaneSize({ 'Up', 1 }) },
		{ key = 'L',      mods = 'SHIFT', action = act.AdjustPaneSize({ 'Right', 1 }) },
		{ key = 's',      mods = 'NONE',  action = act.SplitVertical({ domain = 'CurrentPaneDomain' }) },
		{ key = 'v',      mods = 'NONE',  action = act.SplitHorizontal({ domain = 'CurrentPaneDomain' }) },
		{ key = 'c',      mods = 'NONE',  action = act.CloseCurrentPane({ confirm = false }) },
		{ key = 't',      mods = 'NONE',  action = act.SpawnTab('DefaultDomain') },
		{ key = 'n',      mods = 'NONE',  action = act.SpawnWindow },
		{ key = 'y',      mods = 'NONE',  action = act.ActivateCopyMode },
		{ key = 'Escape', mods = 'NONE',  action = 'PopKeyTable' },
		{ key = 'q',      mods = 'NONE',  action = 'PopKeyTable' },
	},
}

return M
