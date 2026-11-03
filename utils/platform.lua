---@alias PlatformType 'windows' | 'linux' | 'mac' | 'unix-like'

local wezterm = require('wezterm')
local executable_cache = {}
local function is_find(str, pattern)
	return string.find(str, pattern) ~= nil
end

local function check_platform()
	local os = "unix-like"
	local is_win = is_find(wezterm.target_triple, "windows")
	local is_mac = is_find(wezterm.target_triple, "apple")
	local is_linux = is_find(wezterm.target_triple, "linux")
	local is_unix = false

	if is_win then
		os = "windows"
	elseif is_linux then
		os = "linux"
	elseif is_mac then
		os = "mac"
	else
		is_unix = true
	end

	return {
		os = os,
		is_win = is_win,
		is_mac = is_mac,
		is_linux = is_linux,
		is_unix = is_unix,
	}
end

---@type {os: PlatformType, is_win: boolean, is_mac: boolean, is_linux: boolean, is_unix: boolean, find_executable: function}
local platform = check_platform()

---@param name string Executable's file name
---@return string|nil # Executable's Path, if not exist, it will be nil
local function find_executable(name)
	if platform.is_win then
		-- 首先检查当前目录和 PATH 环境变量，不使用外部命令
		local function check_file_exists(filepath)
			local file = io.open(filepath, "r")
			if file then
				file:close()
				return true
			end
			return false
		end

		-- 检查当前目录
		if check_file_exists(name) then
			return name
		end

		-- 检查添加 .exe 扩展名
		if not string.match(name, "%.[^.]+$") then
			local exe_name = name .. ".exe"
			if check_file_exists(exe_name) then
				return exe_name
			end
		end

		-- 检查 PATH 环境变量中的每个目录
		local path_env = os.getenv("PATH")
		if path_env then
			for path_dir in string.gmatch(path_env, "[^;]+") do
				path_dir = path_dir:gsub("\\$", "")

				local full_path = path_dir .. "\\" .. name
				if check_file_exists(full_path) then
					return full_path
				end

				-- 尝试添加 .exe
				if not string.match(name, "%.[^.]+$") then
					local full_path_exe = path_dir .. "\\" .. name .. ".exe"
					if check_file_exists(full_path_exe) then
						return full_path_exe
					end
				end
			end
		end

		return nil
	else
		-- Unix-like 系统
		local command = 'which "' .. name .. '" 2>/dev/null'
		local pipe = io.popen(command)
		if pipe then
			local result = pipe:read("*l")
			pipe:close()

			if result and result ~= "" then
				result = result:gsub("^%s+", ""):gsub("%s+$", "")
				return result
			end
		end
		return nil
	end
end

---@param name string Executable'file name
---@return string|nil # Executable's Path, if not exsit, it will be nil
function platform.find_executable(name)
	if executable_cache[name] ~= nil then
		return executable_cache[name]
	end

	local res = find_executable(name)
	executable_cache[name] = res
	return res
end

return platform
