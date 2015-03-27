" Needed for Vundles
set shell=/bin/bash

" Used for host detection
let hostname = substitute(system('hostname'), '\n', '', '')


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
call vundle#begin("~/.vim/bundles")

" let Vundle manage Vundle, required
Bundle 'gmarik/vundle'

" Add Git stuff, Gedit Gvsplit Gsplit https://github.com/tpope/vim-fugitive
Bundle 'tpope/vim-fugitive'

" Sourrounds paranthesis and stuff https://github.com/tpope/vim-surround
Bundle 'tpope/vim-surround'

" Navigate around numbers easier.. https://github.com/Lokaltog/vim-easymotion
"Bundle 'Lokaltog/vim-easymotion'

"
" Ultrasnips
"
" Track the engine.
Plugin 'SirVer/ultisnips'

" Snippets are separated from the engine. Add this if you want them:
Plugin 'honza/vim-snippets'

" Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"

" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"



call vundle#end()             " required
filetype plugin indent on     " required
"
" Brief help
" :BundleList          - list configured bundles
" :BundleInstall(!)    - install (update) bundles
" :BundleSearch(!) foo - search (or refresh cache first) for foo
" :BundleClean(!)      - confirm (or auto-approve) removal of unused bundles
"
" see :h vundle for more details or wiki for FAQ
" NOTE: comments after Bundle commands are not allowed.

" END OF VUNDLE SETTINGS




filetype on
syntax on
map <S-Insert> <MiddleMouse>
map! <S-Insert> <MiddleMouse>
let fortran_free_source=1
let fortran_have_tabs=1
set number
set ignorecase

" Indent with tabs, align with spaces
" http://vim.wikia.com/wiki/Indent_with_tabs,_align_with_spaces
set noet ci pi sts=0 sw=3 ts=3 


" SHOULD IMPORT THIS: http://vim.wikia.com/wiki/Indent_with_tabs,_align_with_spaces

" Put a colourbar at 72 chars
"set colorcolumn=72

set ruler
set hlsearch


"
" Some vim-latex stuff
" REQUIRED. This makes vim invoke Latex-Suite when you open a tex file.
filetype plugin on

" IMPORTANT: grep will sometimes skip displaying the file name if you
" search in a singe file. This will confuse Latex-Suite. Set your grep
" program to always generate a file-name.
set grepprg=grep\ -nH\ $*

" OPTIONAL: This enables automatic indentation as you type.
"filetype indent on

" OPTIONAL: Starting with Vim 7, the filetype of empty .tex files defaults to
" 'plaintex' instead of 'tex', which results in vim-latex not being loaded.
" The following changes the default filetype back to 'tex':
let g:tex_flavor='latex'


" Colour scheme
if has("gui_running")
	"colorscheme desert
	colorscheme oceandeep
	set mousemodel=popup
endif

" OS Detection
if has('win32')
	behave xterm
	set ffs=unix
	set backspace=2
"elseif has('mac')
"    ......
"elseif has('unix')
"    ......
endif

if hostname == "laptop"
	"cd 
endif
