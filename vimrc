set nocompatible              " be iMproved, required

call plug#begin('~/.vim/plugged')
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plug 'gmarik/Vundle.vim'

" Solarized colour scheme. For some reason, vim-plug was
" giving authentication errors when the short form of
" the repository was used. Speicyfing the full URL
" seems to work
Plug 'https://github.com/altercation/vim-colors-solarized.git'

" YouCompleteMe
Plug 'Valloric/YouCompleteMe'

" YCMGenerator - generates configs for YouCompleteMe
Plug 'rdnetto/YCM-Generator', { 'branch': 'stable'}

" NERD Tree - file explorer for vim
Plug 'scrooloose/nerdtree'

" Ctrl-P - fuzzy file finder
Plug 'kien/ctrlp.vim'

" Better C++ Syntax Highlighting:
Plug 'octol/vim-cpp-enhanced-highlight'

" Track the ultisnips engine.
Plug 'SirVer/ultisnips'

" Snippets are separated from the engine. Add this if you want them:
Plug 'honza/vim-snippets'

" tagbar - allows browsing tags of the current source file
" from ctags. Good for seeing functions, variables, etc.
Plug 'majutsushi/tagbar'

" vim-sleuth - heuristically determines spacing in terms
" of tabs, spaces, etc. based on what's in use in the
" current file and the file around it:
Plug 'tpope/vim-sleuth'

" fugitive - a Git wrapper for vim. Also allows current
" git branch to be shown by vim-airline:
Plug 'tpope/vim-fugitive'

" Plug to assist with commenting out blocks of text:
Plug 'tomtom/tcomment_vim'

" vim-airline: 'Lean & mean status/tabline for vim that's light as air.'
Plug 'bling/vim-airline'

" A plugin to switch between header and source files:
Plug 'derekwyatt/vim-fswitch'

" Plug to help manage vim buffers:
Plug 'jeetsukumaran/vim-buffergator'

" Plug to highlight the variable under the cursor:
Plug 'OrelSokolov/HiCursorWords'

" A plugin to use rtags in vim. (rtags allows for
" code following, some refactoring, etc.)
Plug 'lyuts/vim-rtags'

" kalisi colour scheme:
Plug 'freeo/vim-kalisi'

" Plug to to smart search and replace, easy
" changes from camelCase to snake_case, etc.
Plug 'tpope/vim-abolish'

" Plug to generate doxygen documentation strings:
Plug 'mrtazz/DoxygenToolkit.vim'

" Install fzf, the fuzzy searcher
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

" All of your Plugins must be added before the following line
call plug#end()            " required

" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line

" Add to the runtime path so that custom
" snippets can be found:
set rtp+=~/dotfiles

" Set a colour scheme for vim:
set background=dark
colorscheme kalisi
set t_Co=256

" Turn line numbers on:
set number

" Turn syntax on:
syntax on

" Make searching case-insensitive:
set ignorecase
" When an upper case letter is in the search
" make it case sensitive
set smartcase

" Make diffs appear in vertical splits:
set diffopt+=vertical

" Enable the mouse, even in non-GUI:
set mouse+=a

" Set the make program to be ninja:
set makeprg=ninja
" A shortcut key to change to the build directory
" and build the project:
map <F7> :execute "cd ".g:build_dir<CR> :make<CR>

" Set up keyboard shortbuts for fzf, the fuzzy finder
" This one searches all the files in the current git repo:
map <c-k> :GitFiles<CR>
map <leader><Tab> :Buffers<CR>

" For vim-cpp-enhanced-highlight, turn on highlighting of class scope:
let g:cpp_class_scope_highlight = 1

" Tell vim to set the current directory to the directory
" of the file being opened:
set autochdir

" Have vim reload a file if it has changed outside
" of vim:
set autoread

" Tell vim to look for a tags file in the current
" directory, and all the way up until it finds one:
set tags=./tags;/

" Tell vim that fileformat might be unix or dos.
" This helps with printing DOS line ending properly:
set ffs=unix,dos

" Let YouCompleteMe use tag files for completion as well:
let g:ycm_collect_identifiers_from_tags_files = 1

" Turn off prompting to load .ycm_extra_conf.py:
let g:ycm_confirm_extra_conf = 0

map <F2> :YcmCompleter GoTo<CR>

" Map to get documentation on a symbol:
map <F1> :YcmCompleter GetDoc<CR>

" Map to apply quick fix:
map <F3> :YcmCompleter FixIt<CR>

" Map GetType to an easier key combination:
nnoremap <leader>ty :YcmCompleter GetType<CR>

" Ultisnips config:
" Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
let g:UltiSnipsExpandTrigger="<c-j>"
let g:UltiSnipsJumpForwardTrigger="<c-j>"
let g:UltiSnipsJumpBackwardTrigger="<c-n>"

" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"

" For vim-airline, ensure the status line is always displayed:
set laststatus=2
"
" Enable the list of buffers
let g:airline#extensions#tabline#enabled = 1

" Show just the filename
let g:airline#extensions#tabline#fnamemod = ':t'

" Don't show trailing whitespace warning:
let g:airline_section_warning = ''

" tagbar config. Enable it using this key map:
nmap <F8> :TagbarToggle<CR>
" Have it autofocus on open:
let g:tagbar_autofocus = 1

" Shortcut key to open NERDTree:
map <F5> :NERDTreeToggle<CR>
let NERDTreeChDirMode = 2
nnoremap <leader>n :NERDTree .<CR>

" Mapping for fswitch, to switch between header
" and source:
nmap <silent> <Leader>of :FSHere<cr>

" A key map to run ctags:
nnoremap <leader>ct :!ctags .<CR>

" Key mappings for clang-format, to format source code:
map <leader>f :pyf /usr/share/vim/addons/syntax/clang-format-3.6.py<CR>
