call plug#begin('~/.vim/plugged')
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" YouCompleteMe
Plug 'Valloric/YouCompleteMe'

" YCMGenerator - generates configs for YouCompleteMe
Plug 'rdnetto/YCM-Generator', { 'branch': 'stable'}

" NERD Tree - file explorer for vim
Plug 'scrooloose/nerdtree'

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

" themes for vim-airline:
Plug 'vim-airline/vim-airline-themes'

" A plugin to switch between header and source files:
Plug 'derekwyatt/vim-fswitch'

" Plug to highlight the variable under the cursor:
Plug 'ihacklog/HiCursorWords'

" A plugin to use rtags in vim. (rtags allows for
" code following, some refactoring, etc.)
Plug 'lyuts/vim-rtags'

" Plug to generate doxygen documentation strings:
Plug 'mrtazz/DoxygenToolkit.vim'

" Install fzf, the fuzzy searcher
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

" Base16 color schemes
Plug 'chriskempson/base16-vim'

" Plugin to wrap all the various grep tools, and provide
" some more advanced search functionality
Plug 'mhinz/vim-grepper'

" Plugin to provide a useful start screen in vim:
Plug 'mhinz/vim-startify'

" Plugin to make it easy to delete a buffer and close the file:
Plug 'mhinz/vim-sayonara'

" Distraction-free writing:
Plug 'junegunn/goyo.vim'

" Plugin to allow easy alignment around various symbols (e.g.
" line up a number of lines with equal signs on the equal signs)
Plug 'junegunn/vim-easy-align'

" A plugin to make it easier to use motions to jump
" to words and characters:
Plug 'easymotion/vim-easymotion'

" A plugin to apply vim-airline's theme to tmux, and then
" to snapshot the theme so that it can be loaded up into
" tmux. This doesn't seem to work when running with
" neovim in a truecolour terminal. I'm commenting it out,
" so that next time I need to update my tmux theme, I can
" re-enable this and use it in a 256 colour terminal.
" Plug 'edkolev/tmuxline.vim'

" An asynchronous plugin for linting various
" file types:
Plug 'benekastah/neomake'

" gruvbox colour scheme:
Plug 'morhetz/gruvbox'

" All of your Plugins must be added before the following line
call plug#end()            " required

" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line

" Add to the runtime path so that custom
" snippets can be found:
set rtp+=~/dotfiles

" If we're in neovim, enable true colour
" support:
if has("nvim")
  let $NVIM_TUI_ENABLE_TRUE_COLOR=1
endif

" Set a colour scheme for vim:
colorscheme gruvbox
set background=dark

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

" If we are using neovim, add a mapping to escape out
" of terminal mode:
if exists(':tnoremap')
   tnoremap <Leader>e <C-\><C-n>
endif

" Set the make program to be ninja:
set makeprg=ninja
" A shortcut key to change to the build directory
" and build the project:
map <F7> :execute "cd ".g:build_dir<CR> :make<CR>

" Disable Neomake for C and C++ files, since we use
" YouCompleteMe for them:
let g:neomake_cpp_enabled_makers = []
let g:neomake_c_enabled_makers = []

" Set the Neomake warning and error markers to be
" similar to YouCompleteMe:
let g:neomake_error_sign = {
        \ 'text': '>>',
        \ 'texthl': 'Error',
        \ }

let g:neomake_warning_sign = {
        \ 'text': '>>',
        \ 'texthl': 'PreProc',
        \ }

let g:neomake_informational_sign = {
        \ 'text': '>>',
        \ 'texthl': 'PreProc',
        \ }

let g:neomake_message_sign = {
        \ 'text': '>>',
        \ 'texthl': 'MoreMsg',
        \ }

" Set up keyboard shortbuts for fzf, the fuzzy finder
" This one searches all the files in the current git repo:
map <c-k> :GitFiles<CR>
map <leader><Tab> :Buffers<CR>
map <leader>b :Buffers<CR>

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

" Use the powerline font symbols, for a nicer
" look:
let g:airline_powerline_fonts = 1

" Set airline theme:
let g:airline_theme='gruvbox'

" tagbar config. Enable it using this key map:
nmap <F8> :TagbarToggle<CR>
" Have it autofocus on open:
let g:tagbar_autofocus = 1

" Shortcut key to open NERDTree:
map <F5> :NERDTreeToggle<CR>
let NERDTreeChDirMode = 2
nnoremap <leader>n :NERDTree .<CR>

" Mapping for fswitch, to switch between header
" and source and load it into the current window:
nmap <silent> <Leader>of :FSHere<cr>
" Switch to the file and load it into the window on the right >
nmap <silent> <Leader>ol :FSRight<cr>
" Switch to the file and load it into a new window split on the right >
nmap <silent> <Leader>oL :FSSplitRight<cr>
" Switch to the file and load it into the window on the left >
nmap <silent> <Leader>oh :FSLeft<cr>
" Switch to the file and load it into a new window split on the left >
nmap <silent> <Leader>oH :FSSplitLeft<cr>

" Set up fswitch to work with the directory structures
" I'm currently using:
augroup fswitch_cpp
   au!
   au BufEnter *.h let b:fswitchdst  = 'cpp,hpp,cc,c'
   au BufEnter *.h let b:fswitchlocs = 'reg:/include/src/,reg:/include.*/src/,../src,reg:|include/\w\+|src|,impl'
   au BufEnter *.cpp let b:fswitchdst  = 'hpp,h'
   au BufEnter *.cpp let b:fswitchlocs = 'reg:/src/include/,reg:|src|include/**|,../include'
   au BufEnter *.hpp let b:fswitchdst  = 'h,cpp'
   au BufEnter *.hpp let b:fswitchlocs = 'reg:/include/src/,reg:/include.*/src/,../src,..'
augroup END

" Key mappings for clang-format, to format source code:
map <leader>f :pyf /usr/share/vim/addons/syntax/clang-format-3.6.py<CR>

" Mapping to close the file in the current buffer:
nnoremap <leader>q :Sayonara<cr>
nnoremap <leader>Q :Sayonara!<cr>

" Mapping for easy aligning on symbols:
" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

" Grepper key bindings:
" Define an operator that takes any motion and
" uses it to populate the search prompt:
nmap gs  <plug>(GrepperOperator)
xmap gs  <plug>(GrepperOperator)
" A mapping to search for all occurrences of the word under
" the cursor in the current file
nnoremap <leader>gw   :Grepper -tool search_in_file -cword -noprompt<cr>
" A mapping to search for all occurrences of the word the user enters
" at the prompt in the current file:
nnoremap <leader>gf   :Grepper -tool search_in_file<cr>
" A mapping to search for the user-supplied string using git grep:
nnoremap <leader>gg   :Grepper -tool git<cr>

" Configure grepper. Of note, we configure git grep
" to perform searches throughout the whole repo
" regardless of the directory we are currently in. We also set
" jumping and opening settings. Finally, we define an additional
" tool, which performs grep only on the current file.
let g:grepper     = {
	 \ 'tools': ['ag', 'git', 'grep', 'search_in_file'],
	 \ 'open':    1,
	 \ 'jump':    0,
	 \ 'switch':  1,
	 \ 'git':     { 'grepprg': 'git grep -nI $* -- `git rev-parse --show-toplevel`'},
	 \ 'search_in_file': {
	 \   'grepprg':    'grep -Hn $* $.',
	 \   'grepformat': '%f:%l:%m',
	 \   'escape':     '\$.*[]%#',
	 \ },
	 \ }

" Easy motion mappings to allow searching for one character:
" s{char}to move to {char}
nmap s <Plug>(easymotion-bd-f)
xmap s <Plug>(easymotion-bd-f)

" Easymotion mapping to search for two characters
nmap <Leader>s <Plug>(easymotion-s2)
xmap <Leader>s <Plug>(easymotion-s2)

" Move to line
map <Leader>L <Plug>(easymotion-bd-jk)
nmap <Leader>L <Plug>(easymotion-overwin-line)
