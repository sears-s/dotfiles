local wezterm = require 'wezterm'
local config = wezterm.config_builder()

-- Set theme
config.color_scheme = 'Monokai Pro (Gogh)'

-- Set font that is included with wezterm
config.font = wezterm.font 'JetBrains Mono'
config.font_size = 10.0

-- Simplify tab bar
config.hide_tab_bar_if_only_one_tab = true
config.use_fancy_tab_bar = false

-- Disable key binding that interferes with Sway
-- Would otherwise enable full screen
config.keys = {
  {
    mods = 'ALT',
    key = 'Enter',
    action = wezterm.action.DisableDefaultAssignment
  }
}

-- Set correct TERM
-- Must first download/compile terminfo
config.term = 'wezterm'

return config
