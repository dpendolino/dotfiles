scriptencoding utf-8

let g:python_host_prog = '/usr/bin/python2'
let g:python3_host_prog = '/usr/bin/python'

" https://github.com/junegunn/vim-plug/wiki/tips#automatic-installation
if empty(glob('~/.config/nvim/autoload/plug.vim'))
	silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
		\ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

" vim-sensible
Plug 'https://github.com/tpope/vim-sensible'

" Line up a certain character in each line
Plug 'https://github.com/junegunn/vim-easy-align.git'

" A git UI plugin
Plug 'https://github.com/tpope/vim-fugitive.git'

" Pop-up file manager
Plug 'https://github.com/scrooloose/nerdtree.git'
Plug 'https://github.com/Xuyuanp/nerdtree-git-plugin.git'

" Map F2 to NERDTreeToggle
map <F2> :NERDTreeToggle<CR>

let g:NERDTreeGitStatusIndicatorMapCustom = {
    \ "Modified"  : "*",
    \ "Staged"    : "+",
    \ "Untracked" : "-",
    \ "Renamed"   : "/",
    \ "Unmerged"  : "=",
    \ "Deleted"   : "x",
    \ "Dirty"     : "*",
    \ "Clean"     : "`",
    \ "Unknown"   : "?"
    \ }

let g:NERDTreeIgnore = ['\.pyc$', '\.o$', '\.lib$', '\.a$', '\.dll$', '\.so$', '\.so\.', '\.dylib$', '\.exe$', '\.out$', '\.app$', '\.stackdump$']

" Colour scheme
"Plug 'https://github.com/altercation/vim-colors-solarized.git'
Plug 'https://github.com/frankier/neovim-colors-solarized-truecolor-only.git'

" Add quotes, html tags, etc. around something
Plug 'https://github.com/tpope/vim-surround.git'

" Commenting/uncommenting stuff
Plug 'https://github.com/tpope/vim-commentary.git'

" Consistent editing styles (indent, etc)
Plug 'https://github.com/editorconfig/editorconfig-vim.git'

" Lets you refactor multiple things with ctrl-n
Plug 'terryma/vim-multiple-cursors'

" Open a file to a specific line with 'vim file:line'
Plug 'bogado/file-line'

" Fast fuzzy searching
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
set rtp+=~/.fzf
" map <C-F> :FZF +c -m -x<cr>
map <C-F> :CocCommand fzf-preview.MruFiles <cr>
Plug 'yuki-ycino/fzf-preview.vim', { 'branch': 'release', 'do': ':UpdateRemotePlugins' }
set shell=/bin/bash
let $SHELL = "/bin/bash"
let g:fzf_preview_command = 'ccat --color=always {-1}' " Installed ccat
let g:fzf_preview_use_dev_icons = 1
let g:fzf_preview_filelist_postprocess_command = 'xargs -d "\n" exa --color=always'

" Use true color preview in Neovim
augroup fzf_preview
  autocmd!
  autocmd User fzf_preview#initialized call s:fzf_preview_settings()
augroup END

function! s:fzf_preview_settings() abort
  let g:fzf_preview_command = 'COLORTERM=truecolor ' . g:fzf_preview_command
  let g:fzf_preview_grep_preview_cmd = 'COLORTERM=truecolor ' . g:fzf_preview_grep_preview_cmd
endfunction

" devicons
Plug 'ryanoasis/vim-devicons'

" track mru files
Plug 'Shougo/neomru.vim'

" Start Screen
Plug 'mhinz/vim-startify'

" Deal with trailing whitespace
Plug 'ntpeters/vim-better-whitespace'
map <leader>s :StripWhitespace<CR>

" Highlight indent levels
Plug 'nathanaelkane/vim-indent-guides'
map <C-I> :IndentGuidesToggle<cr>

" Let the '.' command work with other plugins
Plug 'tpope/vim-repeat'

" Colour scheme
Plug 'chriskempson/base16-vim'

" Asynchronous support
Plug 'Shougo/vimproc.vim', {'do' : 'make'}

" Another elegant statusline for vim, extracted from space-vim.
Plug 'liuchengxu/eleline.vim'
set laststatus=2
let g:eleline_powerline_fonts = 1
" let g:eleline_slim = 1

Plug 'neomake/neomake'
let g:neomake_javascript_enabled_makers = ['eslint']
let g:neomake_python_enabled_makers = ['pylint']
let g:neomake_sh_enabled_makers = ['shellcheck']
" let g:neomake_open_list = 2

" Lint
Plug 'ynkdir/vim-vimlparser'
Plug 'syngan/vim-vimlint'

" Fuzzy finder in neovim floating window
" The do hook is highly recommended.
" It will try to build all the optional dependency if cargo exists on your system.
" Plug 'liuchengxu/vim-clap', { 'do': function('clap#helper#build_all') }
" map <C-P> :Clap <cr>
" Build the extra binary if cargo exists on your system.
" Plug 'liuchengxu/vim-clap', { 'do': ':Clap install-binary' }
" map <C-P> :Clap <cr>

" snippets
Plug 'honza/vim-snippets'
Plug 'SirVer/ultisnips'

" vertically split ultisnips edit window
let g:UltiSnipsEditSplit="vertical"

" smart highlight
Plug 'romainl/vim-cool'

" Gist
Plug 'mattn/webapi-vim'
Plug 'mattn/gist-vim'
let g:gist_clip_command = 'xclip -selection clipboard'
let g:gist_post_private = 1


" Narrow Region
Plug 'chrisbra/NrrwRgn'
map <leader>r :NarrowRegion<CR>

" Jump to a specific character
Plug 'easymotion/vim-easymotion'

" TUI
Plug 'skywind3000/vim-quickui'

" Set up Gundo.vim -- vim-mundo, fork with neovim support
Plug 'simnalamburt/vim-mundo'

" Enable persistent undo so that undo history persists across vim sessions
set undofile
set undodir=~/.vim/undo
nnoremap <F5> :MundoToggle<CR>
let g:mundo_right = 1

" Better :terminal commands
Plug 'mklabs/split-term.vim'
set splitright
set splitbelow
let g:disable_key_mappings = 1
let g:split_term_vertical = 1

" Fix lag in Ruby
Plug 'vim-ruby/vim-ruby'
let g:ruby_no_expensive=1

" Syntax highlighting
Plug 'mustache/vim-mustache-handlebars'
Plug 'dag/vim-fish'
Plug 'rust-lang/rust.vim'
Plug 'cespare/vim-toml'
Plug 'sheerun/vim-polyglot'
let g:mustache_abbreviations = 1

" Rust Completion
Plug 'racer-rust/vim-racer'

" Indent object
Plug 'michaeljsmith/vim-indent-object'

" LSP
" Plug 'neovim/nvim-lsp'
" Plug 'autozimu/LanguageClient-neovim', {
"     \ 'branch': 'next',
"     \ 'do': 'bash install.sh',
"     \ }

" " Required for operations modifying multiple buffers like rename.
" set hidden

" let g:LanguageClient_serverCommands = {
"     \ 'rust': ['~/.cargo/bin/rustup', 'run', 'stable', 'rls'],
"     \ 'javascript': ['/usr/local/bin/javascript-typescript-stdio'],
"     \ 'javascript.jsx': ['tcp://127.0.0.1:2089'],
"     \ 'python': ['/usr/bin/pyls'],
"     \ 'ruby': ['~/.rbenv/shims/solargraph', 'stdio'],
"     \ }

" nnoremap <F5> :call LanguageClient_contextMenu()<CR>
" " Or map each action separately
" nnoremap <silent> K :call LanguageClient#textDocument_hover()<CR>
" nnoremap <silent> gd :call LanguageClient#textDocument_definition()<CR>
" nnoremap <silent> <F2> :call LanguageClient#textDocument_rename()<CR>

" Code Formatting
Plug 'sbdchd/neoformat'
let g:neoformat_enabled_python = ['yapf', 'autopep8']
let g:neoformat_enabled_javascript = ['eslint']
let g:neoformat_enabled_bassh = ['shfmt']
let g:neoformat_enabled_rust = ['rustfmt']
" Enable alignment
let g:neoformat_basic_format_align = 1
" Enable tab to spaces conversion
let g:neoformat_basic_format_retab = 1
" Enable trimmming of trailing whitespace
let g:neoformat_basic_format_trim = 1
let g:neoformat_run_all_formatters = 1

" Markdown Preview
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() } }
" let g:mkdp_browser = 'qutebrowser'

" Makrdown Tables
Plug 'dhruvasagar/vim-table-mode'
let g:table_mode_corner='|'

" Smooth scrolling - totally optional
Plug 'psliwka/vim-smoothie'

" ansible
Plug 'pearofducks/ansible-vim', { 'do': './UltiSnips/generate.sh' }

" Testing

" REPL
Plug 'mtikekar/nvim-send-to-term'

" Jupyter
Plug 'bfredl/nvim-ipy'
command! -nargs=0 RunQtConsole call jobstart("jupyter qtconsole --JupyterWidget.include_other_output=True")

let g:ipy_celldef = '^##' " regex for cell start and end

nmap <silent> <leader>jqt :RunQtConsole<Enter>
nmap <silent> <leader>jk :IPython<Space>--existing<Space>--no-window<Enter>
nmap <silent> <leader>jc <Plug>(IPy-RunCell)
nmap <silent> <leader>ja <Plug>(IPy-RunAll)

" Highlight current word in buffer after delay
Plug 'dominikduda/vim_current_word'

" Vim plugin for "jump to defitinition" and "find usages" feature through nice popup ui
Plug 'pechorin/any-jump.nvim'

" Theme
Plug 'arcticicestudio/nord-vim'


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" Begin CoC Setting
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Use release branch (Recommend)
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" TextEdit might fail if hidden is not set.
set hidden

" Some servers have issues with backup files, see #649.
set nobackup
set nowritebackup

" Give more space for displaying messages.
set cmdheight=2

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
set signcolumn=yes

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current
" position. Coc only does snippet and additional edit on confirm.
if has('patch8.1.1068')
  " Use `complete_info` if your (Neo)Vim version supports it.
  inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
else
  imap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
endif

" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current line.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Introduce function text object
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap if <Plug>(coc-funcobj-i)
omap af <Plug>(coc-funcobj-a)

" Use <TAB> for selections ranges.
" NOTE: Requires 'textDocument/selectionRange' support from the language server.
" coc-tsserver, coc-python are the examples of servers that support it.
nmap <silent> <TAB> <Plug>(coc-range-select)
xmap <silent> <TAB> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support.
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline.
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Mappings using CoCList:
" Show all diagnostics.
nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions.
nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
" Show commands.
nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list.
nnoremap <silent> <space>p  :<C-u>CocListResume<CR>

autocmd FileType json syntax match Comment +\/\/.\+$+

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" End CoC Setting
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" adds a floating terminal window
Plug 'voldikss/vim-floaterm'

" Autocorrect
Plug 'sedm0784/vim-you-autocorrect'
nmap <Leader>u <Plug>VimyouautocorrectUndo
nmap ]s <Plug>VimyouautocorrectNext
nmap [s <Plug>VimyouautocorrectPrevious

" easier focus
Plug 'junegunn/goyo.vim'
Plug 'junegunn/limelight.vim'

" latex support
Plug 'lervag/vimtex'
let g:tex_flavor='latex'

" colorizer
Plug 'norcalli/nvim-colorizer.lua'

" python motions
Plug 'jeetsukumaran/vim-pythonsense'

" Abolish: change case
Plug 'tpope/vim-abolish'

" figure out keybindings
Plug 'liuchengxu/vim-which-key'
nnoremap <silent> <leader> :WhichKey '<leader>'<CR>
nnoremap <silent> <localleader> :WhichKey '<localleader>'<CR>

" Sort Motion.vim
Plug 'christoomey/vim-sort-motion'

" Blink curson on movement
" Plug 'danilamihailov/beacon.nvim'

" Better indent when pasting
" Plug 'sickill/vim-pasta'

" Show marks in sidebar
Plug 'kshenoy/vim-signature'

" Define a Variable text object
Plug 'kana/vim-textobj-user'
Plug 'Julian/vim-textobj-variable-segment'
Plug 'coachshea/vim-textobj-markdown'
Plug 'kana/vim-textobj-function'
" allow textobj-function to co-exist w/textobj-markdown
omap <buffer> af <plug>(textobj-markdown-chunk-a)
omap <buffer> if <plug>(textobj-markdown-chunk-i)
omap <buffer> aF <plug>(textobj-markdown-Bchunk-a)
omap <buffer> iF <plug>(textobj-markdown-Bchunk-i)

" custom header/footer
" Plug 'johannesthyssen/vim-signit'
" let g:signit_initials	= 'DJP'
" let g:signit_name	= 'Daniel Pendolino'
" let g:signit_extra_1	= 'https://github.com/dpendolino'

" foldout is an outline-based folding plugin
" Plug 'msuperdock/vim-foldout'
" let g:foldout_save = 1
" noremap <silent> <tab> :call foldout#toggle_fold()<cr>

" Vimspector
" Plug 'puremourning/vimspector'
" let g:vimspector_enable_mappings = 'HUMAN'

" Plug 'ms-jpq/chadtree', {'branch': 'chad', 'do': ':UpdateRemotePlugins'}
" nnoremap <leader>v <cmd>CHADopen<cr>
" lua vim.api.nvim_set_var("chadtree_settings", { use_icons = "emoji" })
" lua vim.api.nvim_set_var("chadtree_ignores", { name = {".*", ".git"} })
" nnoremap <leader>l <cmd>call setqflist([])<cr>

" visually select increasingly larger regions of text using the same key combination
" Plug 'terryma/vim-expand-region'
" map K <Plug>(expand_region_expand)
" map J <Plug>(expand_region_shrink)

" mini-map
" Plug 'wfxr/minimap.vim', {'do': ':!cargo install --locked code-minimap'}

" visually highlight when yanking
" Plug 'machakann/vim-highlightedyank'

" doc generator
" Plug 'kkoomen/vim-doge', { 'do': { -> doge#install() } }

" treesitter!
" Plug 'nvim-treesitter/nvim-treesitter', { 'tag': '6731bcbf7b69501746f1c98bd471695b83c59754' }

" indentline
Plug 'Yggdroot/indentLine'
let g:indentLine_char_list = ['|', '¦', '┆', '┊']

" nginx
Plug 'chr4/nginx.vim'
Plug 'chr4/sslsecure.vim'

Plug 'plasticboy/vim-markdown'

Plug 'fatih/vim-go'
" disable vim-go :GoDef short cut (gd)
" this is handled by LanguageClient [LC]
let g:go_def_mapping_enabled = 0

" buffer tabs
" Plug 'ap/vim-buftabline'

" yaml folding
Plug 'pedrohdz/vim-yaml-folds'

" tpope/vim-unimpaired
Plug 'tpope/vim-unimpaired'

" swap  items in a list
Plug 'AndrewRadev/sideways.vim'

" previews in a pop up
Plug 'voldikss/vim-skylight'
" Configuration **example**
nnoremap <silent>       go    :SkylightJumpTo<CR>
nnoremap <silent>       gp    :SkylightPreview<CR>

" tags
Plug 'ludovicchabant/vim-gutentags'

" End Testing


call plug#end()

" Colours
set termguicolors
set background=dark
colorscheme nord

" Relative line numbers
au BufReadPost * set relativenumber
au BufReadPost * set number

" groups of letters with dashes as words
set iskeyword +=-
set binary

" Disable highlight
nnoremap <leader><space> :noh<CR>

" Re-wrap text
nnoremap <leader>j       gqap
nnoremap <leader>w       :set wrap linebreak nolist<CR>
nnoremap <leader>h       :TOhtml<CR>

" Set up proper wrapping
set wrap
set linebreak

" Spelling
set spell

" Map <leader>r to NarrowRegion
map <leader>r :NarrowRegion<CR>

" Set backspace to not go beyond the new insert, but to go over autoindent and
" end of lines
" set backspace=eol,indent
set backspace=2

" Instead of failing because a file isn't saved, prompt to save the file
set confirm

" Blink instead of beep
set visualbell

" Tabstops
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab

" Smart search
set ignorecase
set smartcase

" Show lines above and below the cursor when scrolling
set scrolloff=4

" Don't automatically comment the next line
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
autocmd BufNewFile,BufRead *.js.erb set ft=javascript.eruby
autocmd BufNewFile,BufRead *.html.erb set ft=html.eruby
autocmd BufNewFile,BufRead *.html.haml set ft=haml
autocmd BufNewFile,BufRead *.ctp set ft=php.html
autocmd BufNewFile,BufRead *.md set ft=markdown
autocmd BufNewFile,BufRead *.hbs set ft=handlebars.html
autocmd BufNewFile,BufRead *.rss setfiletype xml
autocmd BufNewFile,BufRead .envrc set ft=zsh
autocmd BufNewFile,BufRead .envrc-sample set ft=zsh

" Auto-complete for :commands in vim
set wildmenu                    " Show list instead of just completing
set wildmode=list:longest,full  " Command <Tab> completion, list matches, then longest common part, then all.

" Show cursor-position information
set ruler

" Don't add multiple spaces on a join
set nojoinspaces

" Don't scroll all the way left on pgup/pgdn
set nostartofline

" Improved regex
set magic

" Highlight the 80th column
set colorcolumn=80

" Find merge conflict markers
map <leader>fc /\v^[<\|=>]{7}( .*\|$)<CR>
nnoremap <silent> <leader>q gwip

" Make the clipboard work
function! ClipboardYank()
  call system('xclip -i -selection clipboard', @@)
endfunction
function! ClipboardPaste()
  let @@ = system('xclip -o -selection clipboard')
endfunction

" Disable the mouse
set mouse=c

" Return to the same spot in the file that we were at
if has("autocmd")
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
    \| exe "normal! g'\"" | endif
endif

" Re-map ctrl-h/j/k/l to move around in normal mode
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Re-map ctrl-h/j/k/l to move around in terminal mode
tnoremap <C-h> <C-\><C-n><C-w>h
tnoremap <C-j> <C-\><C-n><C-w>j
tnoremap <C-k> <C-\><C-n><C-w>k
tnoremap <C-l> <C-\><C-n><C-w>l

" Make ctrl-w escape insert mode
tnoremap <C-w> <C-\><C-n><C-w>
inoremap <C-w> <esc><C-w>

" Let <enter> enter insert mode (helpful for terminals)
nnoremap <return> i

" treat long lines as break lines (useful when moving around in them)
nnoremap k gk
nnoremap gk k
nnoremap j gj
nnoremap gj j
nnoremap <up> g<up>
nnoremap <down> g<down>

" Full config: when writing or reading a buffer, and on changes in insert and
" normal mode (after 500ms; no delay when writing).
call neomake#configure#automake('nrwi', 500)

" oldfiles uses viminfo, but the default setting is 100
" Change the number by setting it in viminfo with a single quote.
" Ref: viminfo-'
set viminfo='1000

" terminal stuff
tnoremap <Esc> <C-\><C-n>

" coc-spell-checker
vmap <leader>a <Plug>(coc-codeaction-selected)
nmap <leader>a <Plug>(coc-codeaction-selected)

" float term key bindings
""" Configuration example
let g:floaterm_keymap_new    = '<F7>'
let g:floaterm_keymap_prev   = '<F8>'
let g:floaterm_keymap_next   = '<F9>'
let g:floaterm_keymap_toggle = '<F10>'

" insert date
map <leader>D :put =strftime('# %Y-%m-%d %H:%M %a')<CR>
map <leader>d :put =strftime('%Y-%m-%d')<CR>


" Temporary workaround for: https://github.com/neovim/neovim/issues/1716
" if has("nvim")
"   command! W w !sudo -n tee % > /dev/null || echo "Press <leader>w to authenticate and try again"
"   map <leader>w :new<cr>:term sudo true<cr>
" else
"   command! W w !sudo tee % > /dev/null
" end

" reload init.vim
" nnoremap <leader>S <cmd>source $MYVIMRC<cr>

" toggle mouse
" map <F3> <ESC>:exec &mouse!=""? "set mouse=" : "set mouse=nv"<CR>
" map <leader>m <ESC>:exec &mouse!=""? "set mouse=" : "set mouse=nv"<CR>

" Easy PlugUpdate
" nnoremap <leader>U <cmd>PlugUpdate<cr>

" use a different colorscheme while diff'ing
if &diff
    colorscheme	evening
		" set mouse=a
endif

" http://vimcasts.org/episodes/neovim-eyecandy/
" set inccommand=nosplit

" map M <Plug>(textobj-markdown-chunk-i)

" syntax based folding with treesitter
" set foldmethod=expr
" set foldexpr=nvim_treesitter#foldexpr()

" lua <<EOF
" require'nvim-treesitter.configs'.setup {
"   ensure_installed = "all",     -- one of "all", "language", or a list of languages
"   highlight = {
"     enable = true,              -- false will disable the whole extension
"     disable = { },  -- list of language that will be disabled
"   },
" }
" EOF

" disable header folding
" let g:vim_markdown_folding_disabled = 1

" do not use conceal feature, the implementation is not so good
" let g:vim_markdown_conceal = 0

" disable math tex conceal feature
" let g:tex_conceal = ""
" let g:vim_markdown_math = 1

" support front matter of various format
" let g:vim_markdown_frontmatter = 1  " for YAML format
" let g:vim_markdown_toml_frontmatter = 1  " for TOML format
" let g:vim_markdown_json_frontmatter = 1  " for JSON format

" We can also integrate goyo and limelight together with the following setting:
" autocmd! User GoyoEnter Limelight
" autocmd! User GoyoLeave Limelight!
