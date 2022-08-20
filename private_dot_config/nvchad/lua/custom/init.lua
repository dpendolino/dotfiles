-- Please check NvChad docs if you're totally new to nvchad + dont know lua!!
-- This is an example init file in /lua/custom/
-- this init.lua can load stuffs etc too so treat it like your ~/.config/nvim/

-- NOTE: the 4th argument in the map function is be a table i.e options but its most likely un-needed so dont worry about it

-- Stop sourcing filetype.vim
vim.g.did_load_filetypes = 1

--groups of letters with dashes as words
vim.opt.iskeyword:append({ "-", "+", "=" })
-- print(vim.inspect(vim.opt.iskeyword))
vim.opt.binary = true

-- Set up proper wrapping
vim.opt.wrap = true
vim.opt.linebreak = true

-- disable folds
vim.opt.foldenable = false

-- use system clipboard by default
vim.opt.clipboard = "unnamedplus"

-- Auto-complete for :commands in vim
-- Show list instead of just completing
vim.opt.wildmenu = true

-- Command <Tab> completion, list matches, then longest common part, then all.
vim.opt.wildmode = "list:longest,full"

-- Show cursor-position information
vim.opt.ruler = true

-- Don't add multiple spaces on a join
vim.opt.joinspaces = false

-- Don't scroll all the way left on pgup/pgdn
vim.opt.startofline = false

-- Improved regex
vim.opt.magic = true

-- Highlight the 80th column
vim.opt.colorcolumn = "80"

vim.opt.list = true
vim.opt.listchars:append("eol:↴")
vim.opt.listchars:append("space:⋅")

-- Set backspace to not go beyond the new insert, but to go over autoindent and
-- end of lines
-- set backspace=eol,indent
vim.opt.backspace = "2"

-- Instead of failing because a file isn't saved, prompt to save the file
vim.opt.confirm = true

-- Blink instead of beep
vim.opt.visualbell = true

-- Tabstops
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.expandtab = true
vim.opt.shiftround = true

-- Smart search
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Show lines above and below the cursor when scrolling
vim.opt.scrolloff = 4

-- includes
-- pcall(require, "custom.autocmds")
require("custom.autocmds")

vim.cmd([[
function! Redir(cmd, rng, start, end)
	for win in range(1, winnr('$'))
		if getwinvar(win, 'scratch')
			execute win . 'windo close'
		endif
	endfor
	if a:cmd =~ '^!'
		let cmd = a:cmd =~' %'
			\ ? matchstr(substitute(a:cmd, ' %', ' ' . expand('%:p'), ''), '^!\zs.*')
			\ : matchstr(a:cmd, '^!\zs.*')
		if a:rng == 0
			let output = systemlist(cmd)
		else
			let joined_lines = join(getline(a:start, a:end), '\n')
			let cleaned_lines = substitute(shellescape(joined_lines), "'\\\\''", "\\\\'", 'g')
			let output = systemlist(cmd . " <<< $" . cleaned_lines)
		endif
	else
		redir => output
		execute a:cmd
		redir END
		let output = split(output, "\n")
	endif
	vnew
	let w:scratch = 1
	setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile
	call setline(1, output)
endfunction

command! -nargs=1 -complete=command -bar -range Redir silent call Redir(<q-args>, <range>, <line1>, <line2>)
]])
