local wezterm = require("wezterm")
local config = wezterm.config_builder()

config.color_scheme = "Dracula (base16)"
config.enable_tab_bar = true
-- config.window_decorations = "RESIZE"
config.scrollback_lines = 10000
config.audible_bell = "Disabled"
-- config.font = wezterm.font("FiraCode Nerd Font Mono")
-- You can specify some parameters to influence the font selection;
-- for example, this selects a Bold, Italic font variant.
config.font = wezterm.font("JetBrainsMonoNL Nerd Font", { weight = "Bold", italic = true })
config.font_size = 16
config.harfbuzz_features = { "zero", "ss01", "cv05" }
config.freetype_load_flags = "NO_HINTING"

-- don't include tmux pane borders in mouse selection (add │ to default list)
-- don't include normal pipe (|)
config.selection_word_boundary = " \t\n{}[]()\"'`|│"

-- Customize hyperlinks:
--   https://wezfurlong.org/wezterm/hyperlinks.html#implicit-hyperlinks
-- Use the defaults as a base
config.hyperlink_rules = wezterm.default_hyperlink_rules()

-- make username/project paths clickable. this implies paths like the following are for github.
-- ( "nvim-treesitter/nvim-treesitter" | wbthomason/packer.nvim | wez/wezterm | "wez/wezterm.git" )
-- Disabled for now because _path_ names match the regex
-- table.insert(config.hyperlink_rules, {
--   regex = [[["]?([\w\d]{1}[-\w\d]+)(/){1}([-\w\d\.]+)["]?]],
--   format = 'https://www.github.com/$1/$3',
-- })

return config
