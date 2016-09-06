call plug#begin('~/.vim/plugged')

" YouCompleteMe
Plug 'Valloric/YouCompleteMe'

" YCMGenerator - generates configs for YouCompleteMe
Plug 'rdnetto/YCM-Generator', { 'branch': 'stable'}

" Path navigator for vim
Plug 'justinmk/vim-dirvish'

" Better C++ Syntax Highlighting:
Plug 'octol/vim-cpp-enhanced-highlight'

" Track the ultisnips engine.
Plug 'SirVer/ultisnips'

" Snippets are separated from the engine. Add this if you want them:
Plug 'honza/vim-snippets'

" vim-sleuth - heuristically determines spacing in terms
" of tabs, spaces, etc. based on what's in use in the
" current file and the file around it:
Plug 'tpope/vim-sleuth'

" fugitive - a Git wrapper for vim. Also allows current
" git branch to be shown by vim-airline:
Plug 'tpope/vim-fugitive'

" A plugin containing handy pairs of bracket mapping:
Plug 'tpope/vim-unimpaired'

" Sensible defaults that everyone can agree on:
Plug 'tpope/vim-sensible'

" Plug to assist with commenting out blocks of text:
Plug 'tpope/vim-commentary'

" Plugin for working with surroundings of words:
Plug 'tpope/vim-surround'

" Plugin to help manage sessions
Plug 'tpope/vim-obsession'

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
Plug 'justinmk/vim-sneak'

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

" A plugin to facilitate navigating between vim and tmux
Plug 'christoomey/vim-tmux-navigator'

" All of your Plugins must be added before the following line
call plug#end()            " required

" Add to the runtime path so that custom
" snippets can be found:
set rtp+=~/dotfiles

" Enable true colour support:
if has('termguicolors')
  set termguicolors
endif

" Set a colour scheme for vim:
colorscheme gruvbox
set background=dark

" Turn line numbers on:
set number

" Turn relative line numbers on:
set relativenumber

" Make searching case-insensitive:
set ignorecase
" When an upper case letter is in the search
" make it case sensitive
set smartcase

" Make diffs appear in vertical splits:
set diffopt+=vertical

" If we are using neovim, add a mapping to escape out
" of terminal mode:
if exists(':tnoremap')
   tnoremap <Leader>e <C-\><C-n>
endif

" Disable Neomake for C and C++ files, since we use
" YouCompleteMe for them:
let g:neomake_cpp_enabled_makers = []
let g:neomake_c_enabled_makers = []

" Set up keyboard shortbuts for fzf, the fuzzy finder
nnoremap <leader>z :Files<CR>
nnoremap <leader><Tab> :Buffers<CR>
" A mapping to search using ag:
nnoremap <leader>ag :Ag 

" For vim-cpp-enhanced-highlight, turn on highlighting of class scope:
let g:cpp_class_scope_highlight = 1

" Turn off prompting to load .ycm_extra_conf.py:
let g:ycm_confirm_extra_conf = 0
nnoremap <F2> :YcmCompleter GoTo<CR>
" Map to apply quick fix:
nnoremap <F3> :YcmCompleter FixIt<CR>
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
" Turn on integration with vim-obsession
let g:airline#extensions#obsession#enabled = 1

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
" Switch to the file and load it into the window above >
nmap <silent> <Leader>ok :FSAbove<cr>
" Switch to the file and load it into a new window split above >
nmap <silent> <Leader>oK :FSSplitAbove<cr>
" Switch to the file and load it into the window below >
nmap <silent> <Leader>oj :FSBelow<cr>
" Switch to the file and load it into a new window split below >
nmap <silent> <Leader>oJ :FSSplitBelow<cr>

" Set up fswitch to work with the directory structures
" I'm currently using:
augroup fswitch_cpp
   au!
   au BufEnter *.h let b:fswitchdst  = 'cpp,hpp,cc,c'
   au BufEnter *.h let b:fswitchlocs = 'reg:/include/src/,reg:/include.*/src/,../src,reg:|include/\w\+|src|,impl'
   au BufEnter *.cpp let b:fswitchdst  = 'hpp,h'
   au BufEnter *.cpp let b:fswitchlocs = 'reg:/src/include/,reg:|src|include/**|,../include,reg:|src/\(\w\+\)/src|src/\1/include/**|'
   au BufEnter *.hpp let b:fswitchdst  = 'h,cpp'
   au BufEnter *.hpp let b:fswitchlocs = 'reg:/include/src/,reg:/include.*/src/,../src,..'
augroup END

" Set the comment string for certain filetypes to
" double slashes (used for vim-commentary):
augroup FTOptions 
    autocmd!
    autocmd FileType c,cpp,cs,java          setlocal commentstring=//\ %s
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
" A mapping to search for the user-supplied string using git grep:
nnoremap <leader>gg   :Grepper -tool git<cr>

" Configure grepper
let g:grepper     = {
	 \ 'tools': ['ag', 'git', 'grep'],
	 \ 'open':    1,
	 \ 'jump':    0,
	 \ 'switch':  1,
	 \ }

" vim-sneak options to use streak mode, to minimize the numbers
" of steps to get to a location:
let g:sneak#streak = 1

" Startify options
" Set startify to not switch directories when
" opening a file. This lets us stay in the directory
" we opened the editor in:
let g:startify_change_to_dir = 0
