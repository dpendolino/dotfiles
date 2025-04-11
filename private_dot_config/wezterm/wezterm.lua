-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

config.color_scheme = "Dracula (Official)"
config.tab_bar_at_bottom = true
config.use_fancy_tab_bar = true
config.window_decorations = "TITLE|RESIZE"

config.font = wezterm.font("JetBrains Mono")

config.launch_menu = {
  {
    args = { "htop" },
  },
  {
    -- Optional label to show in the launcher. If omitted, a label
    -- is derived from the `args`
    label = "Bash",
    -- The argument array to spawn.  If omitted the default program
    -- will be used as described in the documentation above
    args = { "distrobox-host-exec", "bash", "-l" },

    -- You can specify an alternative current working directory;
    -- if you don't specify one then a default based on the OSC 7
    -- escape sequence will be used (see the Shell Integration
    -- docs), falling back to the home directory.
    -- cwd = "/some/path"

    -- You can override environment variables just for this command
    -- by setting this here.  It has the same semantics as the main
    -- set_environment_variables configuration option described above
    -- set_environment_variables = { FOO = "bar" },
  },
  {
    args = { "distrobox-host-exec", "fish", "-l" },
    label = "Fish",
  },
  {
    args = { "/home/dpendolino/bin/distrobox-fzf" },
    label = "Containers",
  },
}

-- and finally, return the configuration to wezterm
return config
