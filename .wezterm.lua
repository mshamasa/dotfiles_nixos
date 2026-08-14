local wezterm = require("wezterm")
local config = wezterm.config_builder()

config.font_size = 14
config.font = wezterm.font("Mononoki Nerd Font")
config.color_scheme = "tokyonight_night"
config.window_background_opacity = 0.8

config.keys = {
	{
		key = "w",
		mods = "CMD",
		action = wezterm.action.CloseCurrentPane({ confirm = false }),
	},
	-- This will create a new split and run your default program inside it
	{
		key = "/",
		mods = "CMD",
		action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	},
	{
		key = "L",
		mods = "CMD",
		action = wezterm.action.ActivatePaneDirection("Next"),
	},
	{
		key = "H",
		mods = "CMD",
		action = wezterm.action.ActivatePaneDirection("Prev"),
	},
}

return config
