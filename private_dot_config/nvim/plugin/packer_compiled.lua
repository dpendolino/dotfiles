-- Automatically generated packer.nvim plugin loader code

if vim.api.nvim_call_function('has', {'nvim-0.5'}) ~= 1 then
  vim.api.nvim_command('echohl WarningMsg | echom "Invalid Neovim version for packer.nvim! | echohl None"')
  return
end

vim.api.nvim_command('packadd packer.nvim')

local no_errors, error_msg = pcall(function()

  local time
  local profile_info
  local should_profile = false
  if should_profile then
    local hrtime = vim.loop.hrtime
    profile_info = {}
    time = function(chunk, start)
      if start then
        profile_info[chunk] = hrtime()
      else
        profile_info[chunk] = (hrtime() - profile_info[chunk]) / 1e6
      end
    end
  else
    time = function(chunk, start) end
  end
  
local function save_profiles(threshold)
  local sorted_times = {}
  for chunk_name, time_taken in pairs(profile_info) do
    sorted_times[#sorted_times + 1] = {chunk_name, time_taken}
  end
  table.sort(sorted_times, function(a, b) return a[2] > b[2] end)
  local results = {}
  for i, elem in ipairs(sorted_times) do
    if not threshold or threshold and elem[2] > threshold then
      results[i] = elem[1] .. ' took ' .. elem[2] .. 'ms'
    end
  end

  _G._packer = _G._packer or {}
  _G._packer.profile_output = results
end

time([[Luarocks path setup]], true)
local package_path_str = "/home/dpendolino/.cache/nvim/packer_hererocks/2.0.5/share/lua/5.1/?.lua;/home/dpendolino/.cache/nvim/packer_hererocks/2.0.5/share/lua/5.1/?/init.lua;/home/dpendolino/.cache/nvim/packer_hererocks/2.0.5/lib/luarocks/rocks-5.1/?.lua;/home/dpendolino/.cache/nvim/packer_hererocks/2.0.5/lib/luarocks/rocks-5.1/?/init.lua"
local install_cpath_pattern = "/home/dpendolino/.cache/nvim/packer_hererocks/2.0.5/lib/lua/5.1/?.so"
if not string.find(package.path, package_path_str, 1, true) then
  package.path = package.path .. ';' .. package_path_str
end

if not string.find(package.cpath, install_cpath_pattern, 1, true) then
  package.cpath = package.cpath .. ';' .. install_cpath_pattern
end

time([[Luarocks path setup]], false)
time([[try_loadstring definition]], true)
local function try_loadstring(s, component, name)
  local success, result = pcall(loadstring(s))
  if not success then
    vim.schedule(function()
      vim.api.nvim_notify('packer.nvim: Error running ' .. component .. ' for ' .. name .. ': ' .. result, vim.log.levels.ERROR, {})
    end)
  end
  return result
end

time([[try_loadstring definition]], false)
time([[Defining packer_plugins]], true)
_G.packer_plugins = {
  Colorizer = {
    loaded = true,
    path = "/home/dpendolino/.local/share/nvim/site/pack/packer/start/Colorizer",
    url = "https://github.com/chrisbra/Colorizer"
  },
  ["Dockerfile.vim"] = {
    loaded = true,
    path = "/home/dpendolino/.local/share/nvim/site/pack/packer/start/Dockerfile.vim",
    url = "https://github.com/ekalinin/Dockerfile.vim"
  },
  ["HighStr.nvim"] = {
    loaded = true,
    path = "/home/dpendolino/.local/share/nvim/site/pack/packer/start/HighStr.nvim",
    url = "https://github.com/kdav5758/HighStr.nvim"
  },
  ["LanguageTool.nvim"] = {
    loaded = true,
    path = "/home/dpendolino/.local/share/nvim/site/pack/packer/start/LanguageTool.nvim",
    url = "https://github.com/vigoux/LanguageTool.nvim"
  },
  ["clipboard-image.nvim"] = {
    loaded = true,
    path = "/home/dpendolino/.local/share/nvim/site/pack/packer/start/clipboard-image.nvim",
    url = "https://github.com/ekickx/clipboard-image.nvim"
  },
  ["copilot.vim"] = {
    loaded = true,
    path = "/home/dpendolino/.local/share/nvim/site/pack/packer/start/copilot.vim",
    url = "https://github.com/github/copilot.vim"
  },
  ["darcula-solid.nvim"] = {
    loaded = true,
    path = "/home/dpendolino/.local/share/nvim/site/pack/packer/start/darcula-solid.nvim",
    url = "https://github.com/briones-gabriel/darcula-solid.nvim"
  },
  ["diffview.nvim"] = {
    loaded = true,
    path = "/home/dpendolino/.local/share/nvim/site/pack/packer/start/diffview.nvim",
    url = "https://github.com/sindrets/diffview.nvim"
  },
  ["git-messenger.vim"] = {
    loaded = true,
    path = "/home/dpendolino/.local/share/nvim/site/pack/packer/start/git-messenger.vim",
    url = "https://github.com/rhysd/git-messenger.vim"
  },
  ["gitsigns.nvim"] = {
    loaded = true,
    path = "/home/dpendolino/.local/share/nvim/site/pack/packer/start/gitsigns.nvim",
    url = "https://github.com/lewis6991/gitsigns.nvim"
  },
  kommentary = {
    loaded = true,
    path = "/home/dpendolino/.local/share/nvim/site/pack/packer/start/kommentary",
    url = "https://github.com/b3nj5m1n/kommentary"
  },
  ["lsp-rooter.nvim"] = {
    loaded = true,
    path = "/home/dpendolino/.local/share/nvim/site/pack/packer/start/lsp-rooter.nvim",
    url = "https://github.com/ahmedkhalf/lsp-rooter.nvim"
  },
  ["lsp-trouble.nvim"] = {
    config = { "\27LJ\1\0029\0\0\2\0\3\0\a4\0\0\0%\1\1\0>\0\2\0027\0\2\0002\1\0\0>\0\2\1G\0\1\0\nsetup\ftrouble\frequire\0" },
    loaded = true,
    path = "/home/dpendolino/.local/share/nvim/site/pack/packer/start/lsp-trouble.nvim",
    url = "https://github.com/folke/lsp-trouble.nvim"
  },
  ["lualine.nvim"] = {
    config = { "\27LJ\1\2�\4\0\0\5\0\30\00014\0\0\0%\1\1\0>\0\2\0027\0\2\0003\1\b\0003\2\3\0003\3\4\0:\3\5\0023\3\6\0:\3\a\2:\2\t\0013\2\v\0002\3\3\0003\4\n\0;\4\1\3:\3\f\0022\3\3\0003\4\r\0;\4\1\3:\3\14\0022\3\3\0003\4\15\0;\4\1\3:\3\16\0023\3\17\0:\3\18\0023\3\19\0:\3\20\0023\3\21\0:\3\22\2:\2\23\0013\2\24\0002\3\0\0:\3\f\0022\3\0\0:\3\14\0023\3\25\0:\3\16\0023\3\26\0:\3\18\0022\3\0\0:\3\20\0022\3\0\0:\3\22\2:\2\27\0013\2\28\0:\2\29\1>\0\2\1G\0\1\0\15extensions\1\2\0\0\bfzf\22inactive_sections\1\2\0\0\rlocation\1\2\0\0\rfilename\1\0\0\rsections\14lualine_z\1\2\0\0\rlocation\14lualine_y\1\2\0\0\rprogress\14lualine_x\1\4\0\0\rencoding\15fileformat\rfiletype\14lualine_c\1\2\1\0\rfilename\16file_status\2\14lualine_b\1\2\1\0\vbranch\ticon\b\14lualine_a\1\0\0\1\2\1\0\tmode\nupper\2\foptions\1\0\0\25component_separators\1\3\0\0\b\b\23section_separators\1\3\0\0\b\b\1\0\2\18icons_enabled\2\ntheme\tnord\nsetup\flualine\frequire\0" },
    loaded = true,
    path = "/home/dpendolino/.local/share/nvim/site/pack/packer/start/lualine.nvim",
    url = "https://github.com/hoob3rt/lualine.nvim"
  },
  ["lush.nvim"] = {
    loaded = true,
    path = "/home/dpendolino/.local/share/nvim/site/pack/packer/start/lush.nvim",
    url = "https://github.com/rktjmp/lush.nvim"
  },
  neoterm = {
    loaded = true,
    path = "/home/dpendolino/.local/share/nvim/site/pack/packer/start/neoterm",
    url = "https://github.com/kassio/neoterm"
  },
  ["neovim-colors-solarized-truecolor-only.git"] = {
    loaded = true,
    path = "/home/dpendolino/.local/share/nvim/site/pack/packer/start/neovim-colors-solarized-truecolor-only.git",
    url = "https://github.com/frankier/neovim-colors-solarized-truecolor-only"
  },
  ["nord-vim"] = {
    loaded = true,
    path = "/home/dpendolino/.local/share/nvim/site/pack/packer/start/nord-vim",
    url = "https://github.com/arcticicestudio/nord-vim"
  },
  ["numb.nvim"] = {
    loaded = true,
    path = "/home/dpendolino/.local/share/nvim/site/pack/packer/start/numb.nvim",
    url = "https://github.com/nacro90/numb.nvim"
  },
  ["nvim-compe"] = {
    loaded = true,
    path = "/home/dpendolino/.local/share/nvim/site/pack/packer/start/nvim-compe",
    url = "https://github.com/hrsh7th/nvim-compe"
  },
  ["nvim-dap"] = {
    loaded = true,
    path = "/home/dpendolino/.local/share/nvim/site/pack/packer/start/nvim-dap",
    url = "https://github.com/mfussenegger/nvim-dap"
  },
  ["nvim-dap-python"] = {
    loaded = true,
    path = "/home/dpendolino/.local/share/nvim/site/pack/packer/start/nvim-dap-python",
    url = "https://github.com/mfussenegger/nvim-dap-python"
  },
  ["nvim-lastplace"] = {
    loaded = true,
    path = "/home/dpendolino/.local/share/nvim/site/pack/packer/start/nvim-lastplace",
    url = "https://github.com/ethanholz/nvim-lastplace"
  },
  ["nvim-lspconfig"] = {
    loaded = true,
    path = "/home/dpendolino/.local/share/nvim/site/pack/packer/start/nvim-lspconfig",
    url = "https://github.com/neovim/nvim-lspconfig"
  },
  ["nvim-revJ.lua"] = {
    loaded = true,
    path = "/home/dpendolino/.local/share/nvim/site/pack/packer/start/nvim-revJ.lua",
    url = "https://github.com/AckslD/nvim-revJ.lua"
  },
  ["nvim-tree.lua"] = {
    loaded = true,
    path = "/home/dpendolino/.local/share/nvim/site/pack/packer/start/nvim-tree.lua",
    url = "https://github.com/kyazdani42/nvim-tree.lua"
  },
  ["nvim-ts-autotag"] = {
    loaded = false,
    needs_bufread = false,
    path = "/home/dpendolino/.local/share/nvim/site/pack/packer/opt/nvim-ts-autotag",
    url = "https://github.com/windwp/nvim-ts-autotag"
  },
  ["nvim-ts-context-commentstring"] = {
    loaded = true,
    path = "/home/dpendolino/.local/share/nvim/site/pack/packer/start/nvim-ts-context-commentstring",
    url = "https://github.com/JoosepAlviste/nvim-ts-context-commentstring"
  },
  ["nvim-web-devicons"] = {
    loaded = true,
    path = "/home/dpendolino/.local/share/nvim/site/pack/packer/start/nvim-web-devicons",
    url = "https://github.com/kyazdani42/nvim-web-devicons"
  },
  ["packer.nvim"] = {
    loaded = false,
    needs_bufread = false,
    path = "/home/dpendolino/.local/share/nvim/site/pack/packer/opt/packer.nvim",
    url = "https://github.com/wbthomason/packer.nvim"
  },
  ["plenary.nvim"] = {
    loaded = true,
    path = "/home/dpendolino/.local/share/nvim/site/pack/packer/start/plenary.nvim",
    url = "https://github.com/nvim-lua/plenary.nvim"
  },
  ["popup.nvim"] = {
    loaded = true,
    path = "/home/dpendolino/.local/share/nvim/site/pack/packer/start/popup.nvim",
    url = "https://github.com/nvim-lua/popup.nvim"
  },
  spaceduck = {
    loaded = true,
    path = "/home/dpendolino/.local/share/nvim/site/pack/packer/start/spaceduck",
    url = "https://github.com/pineapplegiant/spaceduck"
  },
  ["telescope-fzf-native.nvim"] = {
    loaded = true,
    path = "/home/dpendolino/.local/share/nvim/site/pack/packer/start/telescope-fzf-native.nvim",
    url = "https://github.com/nvim-telescope/telescope-fzf-native.nvim"
  },
  ["telescope.nvim"] = {
    loaded = true,
    path = "/home/dpendolino/.local/share/nvim/site/pack/packer/start/telescope.nvim",
    url = "https://github.com/nvim-telescope/telescope.nvim"
  },
  ["todo-comments.nvim"] = {
    config = { '\27LJ\1\2�\6\0\0\5\0%\0+4\0\0\0%\1\1\0>\0\2\0027\0\2\0003\1\3\0003\2\a\0003\3\4\0003\4\5\0:\4\6\3:\3\b\0023\3\t\0:\3\n\0023\3\v\0:\3\f\0023\3\r\0003\4\14\0:\4\6\3:\3\15\0023\3\16\0003\4\17\0:\4\6\3:\3\18\0023\3\19\0003\4\20\0:\4\6\3:\3\21\2:\2\22\0013\2\23\0:\2\24\0013\2\26\0003\3\25\0:\3\27\0023\3\28\0:\3\29\0023\3\30\0:\3\31\0023\3 \0:\3!\0023\3"\0:\3#\2:\2$\1>\0\2\1G\0\1\0\vcolors\fdefault\1\3\0\0\15Identifier\f#7C3AED\thint\1\3\0\0\30LspDiagnosticsDefaultHint\f#10B981\tinfo\1\3\0\0%LspDiagnosticsDefaultInformation\f#2563EB\fwarning\1\4\0\0!LspDiagnosticsDefaultWarning\15WarningMsg\f#FBBF24\nerror\1\0\0\1\4\0\0\31LspDiagnosticsDefaultError\rErrorMsg\f#DC2626\14highlight\1\0\3\vbefore\5\fkeyword\twide\nafter\afg\rkeywords\tNOTE\1\2\0\0\tINFO\1\0\2\ncolor\thint\ticon\t \tPERF\1\4\0\0\nOPTIM\16PERFORMANCE\rOPTIMIZE\1\0\1\ticon\t \tWARN\1\3\0\0\fWARNING\bXXX\1\0\2\ncolor\fwarning\ticon\t \tHACK\1\0\2\ncolor\fwarning\ticon\t \tTODO\1\0\2\ncolor\tinfo\ticon\t \bFIX\1\0\0\balt\1\6\0\0\nFIXME\bBUG\nFIXIT\bFIX\nISSUE\1\0\2\ncolor\nerror\ticon\t \1\0\1\nsigns\2\nsetup\18todo-comments\frequire\0' },
    loaded = true,
    path = "/home/dpendolino/.local/share/nvim/site/pack/packer/start/todo-comments.nvim",
    url = "https://github.com/folke/todo-comments.nvim"
  },
  vim = {
    loaded = true,
    path = "/home/dpendolino/.local/share/nvim/site/pack/packer/start/vim",
    url = "https://github.com/dracula/vim"
  },
  ["vim-dispatch"] = {
    loaded = true,
    path = "/home/dpendolino/.local/share/nvim/site/pack/packer/start/vim-dispatch",
    url = "https://github.com/tpope/vim-dispatch"
  },
  ["vim-easy-align.git"] = {
    loaded = true,
    path = "/home/dpendolino/.local/share/nvim/site/pack/packer/start/vim-easy-align.git",
    url = "https://github.com/junegunn/vim-easy-align"
  },
  ["vim-fugitive"] = {
    loaded = true,
    path = "/home/dpendolino/.local/share/nvim/site/pack/packer/start/vim-fugitive",
    url = "https://github.com/tpope/vim-fugitive"
  },
  ["vim-fugitive.git"] = {
    loaded = true,
    path = "/home/dpendolino/.local/share/nvim/site/pack/packer/start/vim-fugitive.git",
    url = "https://github.com/tpope/vim-fugitive"
  },
  ["vim-gutentags"] = {
    loaded = true,
    path = "/home/dpendolino/.local/share/nvim/site/pack/packer/start/vim-gutentags",
    url = "https://github.com/ludovicchabant/vim-gutentags"
  },
  ["vim-json"] = {
    loaded = true,
    path = "/home/dpendolino/.local/share/nvim/site/pack/packer/start/vim-json",
    url = "https://github.com/elzr/vim-json"
  },
  ["vim-peekaboo"] = {
    loaded = true,
    path = "/home/dpendolino/.local/share/nvim/site/pack/packer/start/vim-peekaboo",
    url = "https://github.com/junegunn/vim-peekaboo"
  },
  ["vim-rhubarb"] = {
    loaded = true,
    path = "/home/dpendolino/.local/share/nvim/site/pack/packer/start/vim-rhubarb",
    url = "https://github.com/tpope/vim-rhubarb"
  },
  ["vim-sensible"] = {
    loaded = true,
    path = "/home/dpendolino/.local/share/nvim/site/pack/packer/start/vim-sensible",
    url = "https://github.com/tpope/vim-sensible"
  },
  ["vim-startuptime"] = {
    loaded = true,
    path = "/home/dpendolino/.local/share/nvim/site/pack/packer/start/vim-startuptime",
    url = "https://github.com/dstein64/vim-startuptime"
  },
  ["vim-terraform"] = {
    loaded = true,
    path = "/home/dpendolino/.local/share/nvim/site/pack/packer/start/vim-terraform",
    url = "https://github.com/hashivim/vim-terraform"
  },
  ["vim-test"] = {
    loaded = true,
    path = "/home/dpendolino/.local/share/nvim/site/pack/packer/start/vim-test",
    url = "https://github.com/vim-test/vim-test"
  },
  ["vim-textobj-parameter"] = {
    loaded = true,
    path = "/home/dpendolino/.local/share/nvim/site/pack/packer/start/vim-textobj-parameter",
    url = "https://github.com/sgur/vim-textobj-parameter"
  },
  ["vim-ultest"] = {
    loaded = true,
    path = "/home/dpendolino/.local/share/nvim/site/pack/packer/start/vim-ultest",
    url = "https://github.com/rcarriga/vim-ultest"
  },
  vimpeccable = {
    loaded = true,
    path = "/home/dpendolino/.local/share/nvim/site/pack/packer/start/vimpeccable",
    url = "https://github.com/svermeulen/vimpeccable"
  },
  ["which-key.nvim"] = {
    config = { "\27LJ\1\2^\0\0\3\0\6\0\t4\0\0\0%\1\1\0>\0\2\0027\0\2\0003\1\4\0003\2\3\0:\2\5\1>\0\2\1G\0\1\0\vwindow\1\0\0\1\0\1\vborder\vdouble\nsetup\14which-key\frequire\0" },
    loaded = true,
    path = "/home/dpendolino/.local/share/nvim/site/pack/packer/start/which-key.nvim",
    url = "https://github.com/folke/which-key.nvim"
  },
  ["xplr.vim"] = {
    loaded = true,
    path = "/home/dpendolino/.local/share/nvim/site/pack/packer/start/xplr.vim",
    url = "https://github.com/sayanarijit/xplr.vim"
  }
}

time([[Defining packer_plugins]], false)
-- Config for: todo-comments.nvim
time([[Config for todo-comments.nvim]], true)
try_loadstring('\27LJ\1\2�\6\0\0\5\0%\0+4\0\0\0%\1\1\0>\0\2\0027\0\2\0003\1\3\0003\2\a\0003\3\4\0003\4\5\0:\4\6\3:\3\b\0023\3\t\0:\3\n\0023\3\v\0:\3\f\0023\3\r\0003\4\14\0:\4\6\3:\3\15\0023\3\16\0003\4\17\0:\4\6\3:\3\18\0023\3\19\0003\4\20\0:\4\6\3:\3\21\2:\2\22\0013\2\23\0:\2\24\0013\2\26\0003\3\25\0:\3\27\0023\3\28\0:\3\29\0023\3\30\0:\3\31\0023\3 \0:\3!\0023\3"\0:\3#\2:\2$\1>\0\2\1G\0\1\0\vcolors\fdefault\1\3\0\0\15Identifier\f#7C3AED\thint\1\3\0\0\30LspDiagnosticsDefaultHint\f#10B981\tinfo\1\3\0\0%LspDiagnosticsDefaultInformation\f#2563EB\fwarning\1\4\0\0!LspDiagnosticsDefaultWarning\15WarningMsg\f#FBBF24\nerror\1\0\0\1\4\0\0\31LspDiagnosticsDefaultError\rErrorMsg\f#DC2626\14highlight\1\0\3\vbefore\5\fkeyword\twide\nafter\afg\rkeywords\tNOTE\1\2\0\0\tINFO\1\0\2\ncolor\thint\ticon\t \tPERF\1\4\0\0\nOPTIM\16PERFORMANCE\rOPTIMIZE\1\0\1\ticon\t \tWARN\1\3\0\0\fWARNING\bXXX\1\0\2\ncolor\fwarning\ticon\t \tHACK\1\0\2\ncolor\fwarning\ticon\t \tTODO\1\0\2\ncolor\tinfo\ticon\t \bFIX\1\0\0\balt\1\6\0\0\nFIXME\bBUG\nFIXIT\bFIX\nISSUE\1\0\2\ncolor\nerror\ticon\t \1\0\1\nsigns\2\nsetup\18todo-comments\frequire\0', "config", "todo-comments.nvim")
time([[Config for todo-comments.nvim]], false)
-- Config for: lsp-trouble.nvim
time([[Config for lsp-trouble.nvim]], true)
try_loadstring("\27LJ\1\0029\0\0\2\0\3\0\a4\0\0\0%\1\1\0>\0\2\0027\0\2\0002\1\0\0>\0\2\1G\0\1\0\nsetup\ftrouble\frequire\0", "config", "lsp-trouble.nvim")
time([[Config for lsp-trouble.nvim]], false)
-- Config for: lualine.nvim
time([[Config for lualine.nvim]], true)
try_loadstring("\27LJ\1\2�\4\0\0\5\0\30\00014\0\0\0%\1\1\0>\0\2\0027\0\2\0003\1\b\0003\2\3\0003\3\4\0:\3\5\0023\3\6\0:\3\a\2:\2\t\0013\2\v\0002\3\3\0003\4\n\0;\4\1\3:\3\f\0022\3\3\0003\4\r\0;\4\1\3:\3\14\0022\3\3\0003\4\15\0;\4\1\3:\3\16\0023\3\17\0:\3\18\0023\3\19\0:\3\20\0023\3\21\0:\3\22\2:\2\23\0013\2\24\0002\3\0\0:\3\f\0022\3\0\0:\3\14\0023\3\25\0:\3\16\0023\3\26\0:\3\18\0022\3\0\0:\3\20\0022\3\0\0:\3\22\2:\2\27\0013\2\28\0:\2\29\1>\0\2\1G\0\1\0\15extensions\1\2\0\0\bfzf\22inactive_sections\1\2\0\0\rlocation\1\2\0\0\rfilename\1\0\0\rsections\14lualine_z\1\2\0\0\rlocation\14lualine_y\1\2\0\0\rprogress\14lualine_x\1\4\0\0\rencoding\15fileformat\rfiletype\14lualine_c\1\2\1\0\rfilename\16file_status\2\14lualine_b\1\2\1\0\vbranch\ticon\b\14lualine_a\1\0\0\1\2\1\0\tmode\nupper\2\foptions\1\0\0\25component_separators\1\3\0\0\b\b\23section_separators\1\3\0\0\b\b\1\0\2\18icons_enabled\2\ntheme\tnord\nsetup\flualine\frequire\0", "config", "lualine.nvim")
time([[Config for lualine.nvim]], false)
-- Config for: which-key.nvim
time([[Config for which-key.nvim]], true)
try_loadstring("\27LJ\1\2^\0\0\3\0\6\0\t4\0\0\0%\1\1\0>\0\2\0027\0\2\0003\1\4\0003\2\3\0:\2\5\1>\0\2\1G\0\1\0\vwindow\1\0\0\1\0\1\vborder\vdouble\nsetup\14which-key\frequire\0", "config", "which-key.nvim")
time([[Config for which-key.nvim]], false)
if should_profile then save_profiles() end

end)

if not no_errors then
  vim.api.nvim_command('echohl ErrorMsg | echom "Error in packer_compiled: '..error_msg..'" | echom "Please check your config for correctness" | echohl None')
end
