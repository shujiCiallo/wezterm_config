local wezterm = require('wezterm')
local platform = require('utils.platform')

local size = platform.is_mac and 16 or 18
local font = {
	name = 'Maple Mono Normal NF CN',
	size = size,
	settings = {
		weight = 'Regular',
		style = 'Normal',
	},
}

return {
	font = wezterm.font({
		family = font.name,
		style = font.settings.style,
		weight = font.settings.weight,
	}),
	font_size = font.size,

	--ref: https://wezfurlong.org/wezterm/config/lua/config/freetype_pcf_long_family_names.html#why-doesnt-wezterm-use-the-distro-freetype-or-match-its-configuration
	-- freetype_load_target = 'Normal', ---@type 'Normal'|'Light'|'Mono'|'HorizontalLcd'
	-- freetype_render_target = 'Normal', ---@type 'Normal'|'Light'|'Mono'|'HorizontalLcd'
}
