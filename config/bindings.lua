local wezterm = require("wezterm")
local platform = require("utils.platform")
local backdrops = require("utils.backdrops")
local nvim = require("config.nvim-mode")
local act = wezterm.action

local mod = {}

if platform.is_mac then
	mod.SUPER = "SUPER"
	mod.SUPER_REV = "SUPER|CTRL"
elseif platform.is_win or platform.is_linux then
	mod.SUPER = "ALT" -- to not conflict with Windows key shortcuts
	mod.SUPER_REV = "ALT|CTRL"
end

-- stylua: ignore
local keys = {
	-- -- misc/useful --
	{ key = 'F1', mods = 'NONE', action = 'ActivateCopyMode' },
	{ key = 'F2', mods = 'NONE', action = act.ActivateCommandPalette },
	{ key = 'F3', mods = 'NONE', action = act.ShowLauncher },
	{ key = 'F4', mods = 'NONE', action = act.ShowLauncherArgs({ flags = 'FUZZY|TABS' }) },
	{
		key = 'F5',
		mods = 'NONE',
		action = act.ShowLauncherArgs({ flags = 'FUZZY|WORKSPACES' }),
	},
	{ key = 'F11', mods = 'NONE',    action = act.ToggleFullScreen },
	{ key = 'F12', mods = 'NONE',    action = act.ShowDebugOverlay },
	{ key = 'f',   mods = mod.SUPER, action = act.Search({ CaseInSensitiveString = '' }) },
	{
		key = 'u',
		mods = mod.SUPER_REV,
		action = wezterm.action.QuickSelectArgs({
			label = 'open url',
			patterns = {
				'\\((https?://\\S+)\\)',
				'\\[(https?://\\S+)\\]',
				'\\{(https?://\\S+)\\}',
				'<(https?://\\S+)>',
				'\\bhttps?://\\S+[)/a-zA-Z0-9-]+'
			},
			action = wezterm.action_callback(function(window, pane)
				local url = window:get_selection_text_for_pane(pane)
				wezterm.log_info('opening: ' .. url)
				wezterm.open_with(url)
			end),
		}),
	},
	-- reload configuration
	{ key = 'r',          mods = mod.SUPER,                                   action = act.ReloadConfiguration },
	-- quit
	{ key = 'q',          mods = mod.SUPER,                                   action = wezterm.action.QuitApplication, },
	-- cursor movement --
	{ key = 'LeftArrow',  mods = mod.SUPER,                                   action = act.SendString '\u{1b}OH' },
	{ key = 'RightArrow', mods = mod.SUPER,                                   action = act.SendString '\u{1b}OF' },
	{ key = 'Backspace',  mods = mod.SUPER,                                   action = act.SendString '\u{15}' },

	-- copy/paste --
	{ key = 'c',          mods = platform.is_mac and 'SUPER' or 'CTRL|SHIFT', action = act.CopyTo('Clipboard') },
	{ key = 'v',          mods = platform.is_mac and 'SUPER' or 'CTRL|SHIFT', action = act.PasteFrom('Clipboard') },

	-- tabs --
	-- tabs: spawn+close
	{ key = 't',          mods = mod.SUPER,                                   action = act.SpawnTab('DefaultDomain') },
	-- { key = 't',          mods = mod.SUPER_REV, action = act.SpawnTab({ DomainName = 'wsl:ubuntu-fish' }) },
	{ key = 'w',          mods = mod.SUPER_REV,                               action = act.CloseCurrentTab({ confirm = false }) },

	-- tabs: navigation
	{ key = '[',          mods = mod.SUPER,                                   action = act.ActivateTabRelative(-1) },
	{ key = ']',          mods = mod.SUPER,                                   action = act.ActivateTabRelative(1) },
	{ key = '[',          mods = mod.SUPER_REV,                               action = act.MoveTabRelative(-1) },
	{ key = ']',          mods = mod.SUPER_REV,                               action = act.MoveTabRelative(1) },

	-- tab: title
	{ key = '0',          mods = mod.SUPER,                                   action = act.EmitEvent('tabs.manual-update-tab-title') },
	{ key = '0',          mods = mod.SUPER_REV,                               action = act.EmitEvent('tabs.reset-tab-title') },

	-- tab: hide tab-bar
	{ key = '9',          mods = mod.SUPER,                                   action = act.EmitEvent('tabs.toggle-tab-bar'), },

	-- window --
	-- window: spawn windows
	{ key = 'n',          mods = mod.SUPER,                                   action = act.SpawnWindow },

	-- window: zoom window
	{
		key = '-',
		mods = mod.SUPER,
		action = wezterm.action_callback(function(window, _pane)
			local dimensions = window:get_dimensions()
			if dimensions.is_full_screen then
				return
			end
			local new_width = dimensions.pixel_width - 50
			local new_height = dimensions.pixel_height - 50
			window:set_inner_size(new_width, new_height)
		end)
	},
	{
		key = '=',
		mods = mod.SUPER,
		action = wezterm.action_callback(function(window, _pane)
			local dimensions = window:get_dimensions()
			if dimensions.is_full_screen then
				return
			end
			local new_width = dimensions.pixel_width + 50
			local new_height = dimensions.pixel_height + 50
			window:set_inner_size(new_width, new_height)
		end)
	},
	{
		key = 'Enter',
		mods = mod.SUPER_REV,
		action = wezterm.action_callback(function(window, _pane)
			window:maximize()
		end)
	},

	-- background controls --
	{
		key = [[/]],
		mods = mod.SUPER,
		action = wezterm.action_callback(function(window, _pane)
			backdrops:random(window)
		end),
	},
	{
		key = [[,]],
		mods = mod.SUPER,
		action = wezterm.action_callback(function(window, _pane)
			backdrops:cycle_back(window)
		end),
	},
	{
		key = [[.]],
		mods = mod.SUPER,
		action = wezterm.action_callback(function(window, _pane)
			backdrops:cycle_forward(window)
		end),
	},
	{
		key = [[/]],
		mods = mod.SUPER_REV,
		action = act.InputSelector({
			title = 'InputSelector: Select Background',
			choices = backdrops:choices(),
			fuzzy = true,
			fuzzy_description = 'Select Background: ',
			action = wezterm.action_callback(function(window, _pane, idx)
				if not idx then
					return
				end
				---@diagnostic disable-next-line: param-type-mismatch
				backdrops:set_img(window, tonumber(idx))
			end),
		}),
	},
	{
		key = 'b',
		mods = mod.SUPER,
		action = wezterm.action_callback(function(window, _pane)
			backdrops:toggle_focus(window)
		end)
	},

	-- panes --
	-- panes: split panes
	{
		key = [[\]],
		mods = mod.SUPER,
		action = act.SplitVertical({ domain = 'CurrentPaneDomain' }),
	},
	{
		key = [[|]],
		mods = mod.SUPER,
		action = act.SplitHorizontal({ domain = 'CurrentPaneDomain' }),
	},

	-- panes: zoom+close pane
	{ key = 'Enter', mods = mod.SUPER,     action = act.TogglePaneZoomState },
	{ key = 'w',     mods = mod.SUPER,     action = act.CloseCurrentPane({ confirm = false }) },

	-- panes: navigation
	{ key = 'k',     mods = mod.SUPER_REV, action = act.ActivatePaneDirection('Up') },
	{ key = 'j',     mods = mod.SUPER_REV, action = act.ActivatePaneDirection('Down') },
	{ key = 'h',     mods = mod.SUPER_REV, action = act.ActivatePaneDirection('Left') },
	{ key = 'l',     mods = mod.SUPER_REV, action = act.ActivatePaneDirection('Right') },
	{
		key = 'p',
		mods = mod.SUPER_REV,
		action = act.PaneSelect({ alphabet = '1234567890', mode = 'SwapWithActiveKeepFocus' }),
	},

	-- panes: scroll pane
	{ key = 'u',        mods = mod.SUPER, action = act.ScrollByLine(-5) },
	{ key = 'd',        mods = mod.SUPER, action = act.ScrollByLine(5) },
	{ key = 'PageUp',   mods = 'NONE',    action = act.ScrollByPage(-0.75) },
	{ key = 'PageDown', mods = 'NONE',    action = act.ScrollByPage(0.75) },

	-- key-tables --
	-- resizes fonts
	{
		key = 'f',
		mods = 'LEADER',
		action = act.ActivateKeyTable({
			name = 'resize_font',
			one_shot = false,
			timemout_milliseconds = 1000,
		}),
	},
	-- resize panes
	{
		key = 'p',
		mods = 'LEADER',
		action = act.ActivateKeyTable({
			name = 'resize_pane',
			one_shot = false,
			timemout_milliseconds = 1000,
		}),
	},
	-- nvim 风格「Normal 模式」键盘层（hjkl 导航 / HJKL 缩放 / s 分屏 ...）
	{
		key = 'v',
		mods = 'LEADER',
		action = act.ActivateKeyTable({
			name = 'nvim_mode',
			one_shot = false,
			timeout_milliseconds = 3000,
		}),
	},
}

-- 注入 smart-splits（插件或内置兜底）生成的分屏快捷键
local split_keys, split_backend = nvim.resolve_keys()
for _, k in ipairs(split_keys) do
	table.insert(keys, k)
end
wezterm.log_info('pane split keys backend: ' .. split_backend)

-- stylua: ignore
local key_tables = {
	resize_font = {
		{ key = 'k',      action = act.IncreaseFontSize },
		{ key = 'j',      action = act.DecreaseFontSize },
		{ key = 'r',      action = act.ResetFontSize },
		{ key = 'Escape', action = 'PopKeyTable' },
		{ key = 'q',      action = 'PopKeyTable' },
	},
	resize_pane = {
		{ key = 'k',      action = act.AdjustPaneSize({ 'Up', 1 }) },
		{ key = 'j',      action = act.AdjustPaneSize({ 'Down', 1 }) },
		{ key = 'h',      action = act.AdjustPaneSize({ 'Left', 1 }) },
		{ key = 'l',      action = act.AdjustPaneSize({ 'Right', 1 }) },
		{ key = 'Escape', action = 'PopKeyTable' },
		{ key = 'q',      action = 'PopKeyTable' },
	},
}

-- 合并 config/nvim-mode.lua 里的 copy_mode / nvim_mode 键表
for name, tbl in pairs(nvim.key_tables) do
	key_tables[name] = tbl
end

local mouse_bindings = {
	-- Ctrl-click will open the link under the mouse cursor
	{
		event = { Up = { streak = 1, button = "Left" } },
		mods = "CTRL",
		action = act.OpenLinkAtMouseCursor,
	},
}

return {
	disable_default_key_bindings = true,
	-- disable_default_mouse_bindings = true,
	leader = { key = "Space", mods = mod.SUPER_REV },
	keys = keys,
	key_tables = key_tables,
	mouse_bindings = mouse_bindings,
}
