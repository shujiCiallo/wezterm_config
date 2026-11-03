---@alias LaunchMenu {label: string, args: string[]}
---@type {default_prog: string[], menu: LaunchMenu[]}
local wezterm = require('wezterm')
local platform = require('utils.platform')
local options = {
	default_prog = {},
	launch_menu = {},
}
local platform = require('utils.platform')
if platform.is_win then
	options.default_prog = {
		'pwsh.exe',
		'-NoLogo',
		'-NoExit',
	}
	options.launch_menu = {
		{
			label = 'Powershell 7',
			args = { 'pwsh.exe', '-NoLogo', '-NoExit' },
		},
		{
			label = 'Powershell',
			args = { 'powershell.exe', '-NoLogo', 'NoExit', 'chcp 65001' },
		},
		{
			label = 'CMD',
			args = { 'cmd.exe', '/k', 'chcp 65001' },
		},
	}
else
	if platform.find_executable('fish') then
		options.default_prog = {
			'fish',
			'--login',
			'--interactive',
		}
		table.insert(options.launch_menu, {
			label = 'Fish',
			args = {
				'fish',
				'--login',
				'--interactive',
			},
		})
	elseif platform.find_executable('zsh') then
		options.default_prog = {
			'zsh',
			'--login',
			'--interactive',
		}
	else
		options.default_prog = {
			'bash',
			'--login',
			'-i',
		}
	end
	if platform.find_executable('zsh') then
		table.insert(options.launch_menu, {
			label = 'Zsh',
			args = {
				'zsh',
				'--login',
				'--interactive',
			},
		})
	end
	table.insert(options.launch_menu, {
		label = 'Bash',
		args = {
			'bash',
			'--login',
			'-i',
		},
	})
end

wezterm.log_info(options)
return options
