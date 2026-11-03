-- A slightly altered version of catppucchin mocha
-- stylua: ignore
-- # Catppuccin Mocha
-- [colors]
-- foreground = "#cdd6f4"
-- background = "#1e1e2e"
-- cursor_bg = "#f5e0dc"
-- cursor_border = "#f5e0dc"
-- cursor_fg = "#1e1e2e"
-- selection_bg = "#585b70"
-- selection_fg = "#cdd6f4"
--
-- ansi = ["#45475a","#f38ba8","#a6e3a1","#f9e2af","#89b4fa","#f5c2e7","#94e2d5","#a6adc8"]
-- brights = ["#585b70","#f37799","#89d88b","#ebd391","#74a8fc","#f2aede","#6bd7ca","#bac2de"]
local mocha = {
   rosewater = '#f5e0dc',
   flamingo  = '#f2cdcd',
   pink      = '#f5c2e7',
   mauve     = '#cba6f7',
   red       = '#f38ba8',
   maroon    = '#eba0ac',
   peach     = '#fab387',
   yellow    = '#f9e2af',
   green     = '#a6e3a1',
   teal      = '#94e2d5',
   sky       = '#89dceb',
   sapphire  = '#74c7ec',
   blue      = '#89b4fa',
   lavender  = '#b4befe',
   text      = '#cdd6f4',
   subtext1  = '#bac2de',
   subtext0  = '#a6adc8',
   overlay2  = '#9399b2',
   overlay1  = '#7f849c',
   overlay0  = '#6c7086',
   surface2  = '#585b70',
   surface1  = '#45475a',
   surface0  = '#313244',
   base      = '#1e1e2e',
   mantle    = '#181825',
   crust     = '#1e1e2e',
}

local colorscheme = {
    foreground = mocha.text,
    background = mocha.base,
    cursor_bg = mocha.rosewater,
    cursor_border = mocha.rosewater,
    cursor_fg = mocha.crust,
    selection_bg = mocha.surface2,
    selection_fg = mocha.text,
    ansi = {
        '#45475a', -- black
        '#f38ba8', -- red
        '#a6e3a1', -- green
        '#f9e2af', -- yellow
        '#89b4fa', -- blue
        '#f5c2e7', -- magenta/purple
        '#94e2d5', -- cyan
        '#a6adc8', -- white
    },
    brights = {
        '#585b70', -- black
        '#f37799', -- red
        '#89d88b', -- green
        '#ebd391', -- yellow
        '#74a8fc', -- blue
        '#f2aede', -- magenta/purple
        '#6bd7ca', -- cyan
        '#bac2de', -- white
    },
    tab_bar = {
        background = 'rgba(0, 0, 0, 0.4)',
        active_tab = {
            bg_color = mocha.surface2,
            fg_color = mocha.text,
        },
        inactive_tab = {
            bg_color = mocha.surface0,
            fg_color = mocha.subtext1,
        },
        inactive_tab_hover = {
            bg_color = mocha.surface0,
            fg_color = mocha.text,
        },
        new_tab = {
            bg_color = mocha.base,
            fg_color = mocha.text,
        },
        new_tab_hover = {
            bg_color = mocha.mantle,
            fg_color = mocha.text,
            italic = true,
        },
    },
    visual_bell = mocha.red,
    indexed = {
        [16] = mocha.peach,
        [17] = mocha.rosewater,
    },
    scrollbar_thumb = mocha.surface2,
    split = mocha.overlay0,
    compose_cursor = mocha.flamingo,
}

return colorscheme
