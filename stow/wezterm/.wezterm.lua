-- Pull in the wezterm API
local wezterm = require 'wezterm'
local act = wezterm.action

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- This is where you actually apply your config choices

-- For example, changing the color scheme:
config.color_scheme = 'Gruvbox dark, soft (base16)'

config.font = wezterm.font 'Maple Mono'
config.font_size = 13.0

-- Wezterm was grabbing CTRL-+ and CTRL-- for font size changes, but I
-- use those in tmux, so I'm disabling them here.
config.keys = {
  { key = '+', mods = 'CTRL', action = act.DisableDefaultAssignment },
  { key = '+', mods = 'SHIFT|CTRL', action = act.DisableDefaultAssignment },
  { key = '+', mods = 'SUPER', action = act.IncreaseFontSize },
  { key = '-', mods = 'CTRL', action = act.DisableDefaultAssignment },
  { key = '-', mods = 'SHIFT|CTRL', action = act.DisableDefaultAssignment },
  { key = '-', mods = 'SUPER', action = act.DecreaseFontSize },
}

-- and finally, return the configuration to wezterm
return config
