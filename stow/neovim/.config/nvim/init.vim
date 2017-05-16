call plug#begin('~/.vim/plugged')

Plug 'Valloric/YouCompleteMe' " YouCompleteMe
Plug 'justinmk/vim-dirvish' " Path navigator for vim
Plug 'octol/vim-cpp-enhanced-highlight' " Better C++ Syntax Highlighting:
Plug 'SirVer/ultisnips' " Track the ultisnips engine.
Plug 'honza/vim-snippets' " Snippets are separated from the engine. Add this if you want them:
Plug 'dawikur/algorithm-mnemonics.vim' " C++ algorithm snippets for Ultisnips
Plug 'tpope/vim-sleuth' " heuristically determine spacing to use when tabbing
Plug 'tpope/vim-fugitive' " git wrapper for vim
Plug 'tpope/vim-unimpaired' " A plugin containing handy pairs of bracket mapping:

if !has('nvim')
  " Neovim has these sensible defaults already
  Plug 'tpope/vim-sensible' " Sensible defaults that everyone can agree on
endif

Plug 'tpope/vim-commentary' " Plug to assist with commenting out blocks of text:
Plug 'tpope/vim-surround' " Plugin for working with surroundings of words:
Plug 'tpope/vim-obsession' " Plugin to help manage sessions
Plug 'bling/vim-airline' " vim-airline: 'Lean & mean status/tabline for vim that's light as air.'
Plug 'vim-airline/vim-airline-themes' " themes for vim-airline:
Plug 'derekwyatt/vim-fswitch' " A plugin to switch between header and source files:
Plug 'ihacklog/HiCursorWords' " Plug to highlight the variable under the cursor:
Plug 'lyuts/vim-rtags' " Plugin to integrate rtags with vim (C++ tags)
Plug 'mrtazz/DoxygenToolkit.vim' " Plug to generate doxygen documentation strings:
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' } " The fuzzy searcher
Plug 'junegunn/fzf.vim'
Plug 'mhinz/vim-startify' " Plugin to provide a useful start screen in vim:
Plug 'mhinz/vim-sayonara' " Plugin to make it easy to delete a buffer and close the file:
Plug 'tommcdo/vim-lion' " Easily align around various symbols
Plug 'justinmk/vim-sneak' " Motion that takes two characters and jumps to occurences
Plug 'benekastah/neomake' " Asynchronous linting
Plug 'morhetz/gruvbox' " gruvbox colour scheme:
Plug 'christoomey/vim-tmux-navigator' " A plugin to facilitate navigating between vim and tmux
Plug 'wellle/targets.vim' " A plugin for additional text objects

" A plugin to apply vim-airline's theme to tmux, and then
" to snapshot the theme so that it can be loaded up into
" tmux. This doesn't seem to work when running with
" neovim in a truecolour terminal. I'm commenting it out,
" so that next time I need to update my tmux theme, I can
" re-enable this and use it in a 256 colour terminal.
" Plug 'edkolev/tmuxline.vim'

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

" Location of clang
let g:clang_path = "/opt/llvm"

" neomake configuration
let g:neomake_cpp_enabled_makers = ['clangtidy']
let g:neomake_cpp_clangtidy_maker = {
   \ 'exe': g:clang_path . '/bin/clang-tidy',
   \ 'args': ['-checks=*' ],
   \}
" Open error list automatically:
let g:neomake_open_list = 2
" Set up map for running Neomake:
nnoremap <leader>n :Neomake<CR>

" Key mappings for clang-format, to format source code.
" map <expr> allows expansion of the variable for the
" clang path.
map <expr> <leader>f ":pyf " . g:clang_path . "/share/clang/clang-format.py<CR>"

" Set up keyboard shortbuts for fzf, the fuzzy finder
nnoremap <leader>z :Files<CR>
nnoremap <leader><Tab> :Buffers<CR>
nnoremap <leader>h :History:<CR>
nnoremap <leader>/ :History/<CR>
" A mapping to search using ag:
nnoremap <leader>ag :Ag<space>
" A command to enable case-sensitive search with Ag:
command! -bang -nargs=* Ags
  \ call fzf#vim#grep('ag --nogroup --column --color -s '.shellescape(<q-args>), 0, <bang>0)
" A mapping to do case-insensitive search using ag:
nnoremap <leader>as :Ags<space>

" Use The Silver Searcher for grep, if available:
if executable('ag')
  " Use ag over grep
  set grepprg=ag\ --nogroup\ --nocolor
endif

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
    autocmd FileType cmake                  setlocal commentstring=#\ %s
augroup END

" Mapping to close the file in the current buffer:
nnoremap <leader>q :Sayonara<cr>
nnoremap <leader>Q :Sayonara!<cr>

" vim-sneak options to use streak mode, to minimize the numbers
" of steps to get to a location:
let g:sneak#streak = 1

" Startify options
" Set startify to not switch directories when
" opening a file. This lets us stay in the directory
" we opened the editor in:
let g:startify_change_to_dir = 0

" mappings for fugitive:
nnoremap <leader>gs :Gstatus<cr>
nnoremap <leader>gd :Gdiff<cr>
nnoremap <leader>gb :Gblame<cr>
