" Needed for Vundles
set shell=/bin/bash

" Used for host detection
let hostname = substitute(system('hostname'), '\n', '', '')

if has("win32")||has("win32unix")
	let is_win=1
else
	let is_win=0
endif


" Read .html.base files as .html, this is used in Mayofest
au BufNewFile,BufRead *.html.base set filetype=html

" ftn90 = fortran
au BufNewFile,BufRead *.ftn90 set filetype=fortran

"
" Vundle.  use :PluginInstall to install all these plugins
"

" set the runtime path to include Vundle and initialize
set nocompatible              " be iMproved, required
filetype off                  " required
set rtp+=~/dotfiles/vundle/
call vundle#begin("~/dotfiles/vundle/bundles") " This always fails the second time around

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'


" Sourrounds paranthesis and stuff https://github.com/tpope/vim-surround
"Plugin 'tpope/vim-surround'

" Navigate around numbers easier.. https://github.com/Lokaltog/vim-easymotion
"Plugin 'Lokaltog/vim-easymotion'



" Solarized colour scheme
Plugin 'altercation/vim-colors-solarized.git'

if is_win==0
	" YouCompleteMe
	Plugin 'Valloric/YouCompleteMe'

	" YCMGenerator - generates configs for YouCompleteMe
	Plugin 'rdnetto/YCM-Generator'
endif

" NERD Tree - file explorer for vim
Plugin 'scrooloose/nerdtree'

" Ctrl-P - fuzzy file finder
Plugin 'kien/ctrlp.vim'

" Better C++ Syntax Highlighting:
Plugin 'octol/vim-cpp-enhanced-highlight'

if is_win==0
	" Track the ultisnips engine.
	Plugin 'SirVer/ultisnips'

	" Snippets are separated from the engine. Add this if you want them:
	Plugin 'honza/vim-snippets'
endif

" tagbar - allows browsing tags of the current source file
" from ctags. Good for seeing functions, variables, etc.
Plugin 'majutsushi/tagbar'

" vim-sleuth - heuristically determines spacing in terms
" of tabs, spaces, etc. based on what's in use in the
" current file and the file around it:
Plugin 'tpope/vim-sleuth'

" fugitive - a Git wrapper for vim. Also allows current
" git branch to be shown by vim-airline:
Plugin 'tpope/vim-fugitive'
set diffopt+=vertical

" Plugin to assist with commenting out blocks of text:
Plugin 'tomtom/tcomment_vim'

" vim-airline: 'Lean & mean status/tabline for vim that's light as air.'
Plugin 'bling/vim-airline'

if is_win==0
	" A plugin to manage cscope - a tool to help navigate
	" a codebase.
	Plugin 'brookhong/cscope.vim'
endif

" Switch between header and source files:
Plugin 'vim-scripts/a.vim'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line



"" Random Function
"" http://mo.morsi.org/blog/node/299
"function! s:Rand(max)
"y a         
"redir @b    
"ruby << EOF
"	rmax = VIM::evaluate("a:max")
"	rmax = nil if rmax == ""
"	printf rand(rmax).to_s
"EOF
"redir END 
"let @a = strpart(@a, 0, strlen(@a) - 1)
"let @b = strpart(@b, 1, strlen(@b) - 1)
"let @c = @a . @b
".s/.*/\=@c/g
"endfunction
"command! -nargs=? Rand :call <SID>Rand(<q-args>)


" Colour scheme
if has("gui_running")
	set mousemodel=popup

	"colorscheme desert
	"colorscheme oceandeep

	set background=light
	colorscheme solarized
endif

" OS Detection
if has("win32")||has("win32unix")
	behave xterm
	set ffs=unix
	set backspace=2
"elseif has('mac')
"    ......
"elseif has('unix')
"	let matt="is_unix"
endif

if hostname == "laptop"
	"cd 
endif

""""""""""""""""""""""" Ctrl-P """"""""""""""""""""""""
" Set up Ctrl-P shortcut key for Ctrl-P:
let g:ctrlp_map = '<c-k>'
let g:ctrlp_cmd = 'CtrlP'
map <c-m> :CtrlPTag<CR>
"""""""""""""""""""""" /Ctrl-P """"""""""""""""""""""""

" For vim-cpp-enhanced-highlight, turn on highlighting of class scope:
let g:cpp_class_scope_highlight = 1

" Tell vim to set the current directory to the directory
" of the file being opened:
set autochdir

" Tell vim to look for a tags file in the current
" directory, and all the way up until it finds one:
set tags=./tags;/

""""""""""""""""""""""" YCM Config """"""""""""""""""""""""
if has('unix')
	" Let YouCompleteMe use tag files for completion as well:
	let g:ycm_collect_identifiers_from_tags_files = 1

	" Turn off prompting to load .ycm_extra_conf.py:
	let g:ycm_confirm_extra_conf = 0
endif
"""""""""""""""""""""" /YCM Config """"""""""""""""""""""""

"""""""""""""""""""" Ultisnips config """"""""""""""""""""""
" Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
if is_win==0
	let g:UltiSnipsExpandTrigger="<c-j>"
	let g:UltiSnipsJumpForwardTrigger="<c-j>"
	let g:UltiSnipsJumpBackwardTrigger="<c-n>"

	" If you want :UltiSnipsEdit to split your window.
	let g:UltiSnipsEditSplit="vertical"
endif
""""""""""""""""""" /Ultisnips config """"""""""""""""""""""


""""""""""""""""""""" Airline Config """"""""""""""""""""""
" For vim-airline, ensure the status line is always displayed:
set laststatus=2
"""""""""""""""""""" /Airline Config """"""""""""""""""""""


""""""""""""""""""""" Tagbar Config """"""""""""""""""""""
" tagbar config. Enable it using this key map:
nmap <F8> :TagbarToggle<CR>
"""""""""""""""""""" /Tagbar Config """"""""""""""""""""""


""""""""""""""""""""" NERDTree """"""""""""""""""""""
" Shortcut key to open NERDTree:
map <F5> :NERDTreeToggle<CR>
"""""""""""""""""""" /NERDTree """"""""""""""""""""""


""""""""""""""""""""" cscope """"""""""""""""""""""
" cscope keyboard mapping:
nnoremap <leader>fa :call CscopeFindInteractive(expand('<cword>'))<CR>
nnoremap <leader>l :call ToggleLocationList()<CR>
"""""""""""""""""""" /cscope """"""""""""""""""""""


"""""""""""""""""""" ctags """""""""""""""""""""""
" A key map to run ctags:
nnoremap <leader>ct :!ctags .<CR>
"""""""""""""""""""" /ctags """"""""""""""""""""""

" JsHints
"JSHintToggle

filetype on
syntax on
map <S-Insert> <MiddleMouse>
map! <S-Insert> <MiddleMouse>
let fortran_free_source=1
let fortran_have_tabs=1
set number
set ignorecase
set ts=3


"set ruler
set hlsearch

