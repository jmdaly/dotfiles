set nocompatible              " be iMproved, required
filetype off                  " required

" Read .html.base files as .html, this is used in Mayofest
au BufNewFile,BufRead *.html.base set filetype=html

" ftn90 = fortran
au BufNewFile,BufRead *.ftn90 set filetype=fortran

"" set the runtime path to include Vundle and initialize
"set rtp+=~/.vim/bundle/vundle/
"call vundle#rc()
"" alternatively, pass a path where Vundle should install bundles
""let path = '~/some/path/here'
""call vundle#rc(path)
"
"" let Vundle manage Vundle, required
"Bundle 'gmarik/vundle'
"
"" The following are examples of different formats supported.
"" Keep bundle commands between here and filetype plugin indent on.
"" scripts on GitHub repos
"Bundle 'tpope/vim-fugitive'
"Bundle 'Lokaltog/vim-easymotion'
"Bundle 'tpope/vim-rails.git'
"" The sparkup vim script is in a subdirectory of this repo called vim.
"" Pass the path to set the runtimepath properly.
"Bundle 'rstacruz/sparkup', {'rtp': 'vim/'}
"" scripts from http://vim-scripts.org/vim/scripts.html
"Bundle 'L9'
"Bundle 'FuzzyFinder'
"" scripts not on GitHub
"Bundle 'git://git.wincent.com/command-t.git'
"" git repos on your local machine (i.e. when working on your own plugin)
"Bundle 'file:///home/gmarik/path/to/plugin'
"" ...

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

syntax on
map <S-Insert> <MiddleMouse>
map! <S-Insert> <MiddleMouse>
let fortran_free_source=1
let fortran_have_tabs=1
set number
set ignorecase
set tabstop=4
set shiftwidth=0

" SHOULD IMPORT THIS: http://vim.wikia.com/wiki/Indent_with_tabs,_align_with_spaces

" Put a colourbar at 72 chars
"set colorcolumn=72

set ruler
set hlsearch

"
"
" Pathogen stuff
"execute pathogen#infect()


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
colorscheme desert

" Indent with tabs, align with spaces
" http://vim.wikia.com/wiki/Indent_with_tabs,_align_with_spaces
set noet ci pi sts=0 sw=4 ts=4 
