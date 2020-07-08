" Use space as leader:
let mapleader = "\<Space>"

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
Plug 'itchyny/lightline.vim' " Status line plugin
Plug 'RRethy/vim-illuminate' " Plugin to highlight the word under the cursor
Plug 'mrtazz/DoxygenToolkit.vim' " Plug to generate doxygen documentation strings:
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' } " The fuzzy searcher
Plug 'junegunn/fzf.vim'
Plug 'mhinz/vim-startify' " Plugin to provide a useful start screen in vim:
Plug 'mhinz/vim-sayonara' " Plugin to make it easy to delete a buffer and close the file:
Plug 'tommcdo/vim-lion' " Easily align around various symbols
Plug 'justinmk/vim-sneak' " Motion that takes two characters and jumps to occurences
Plug 'arcticicestudio/nord-vim' " nord colour scheme
Plug 'christoomey/vim-tmux-navigator' " A plugin to facilitate navigating between vim and tmux
Plug 'wellle/targets.vim' " A plugin for additional text objects
Plug 'w0rp/ale' " A plugin for asynchronous linting while you type
Plug 'maximbaz/lightline-ale' " A plugin to show lint errors in lightline
Plug 'leafgarland/typescript-vim' " A plugin for typescript syntax highlighting

" Plug 'prabirshrestha/async.vim'
" Plug 'prabirshrestha/vim-lsp'

Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': 'bash install.sh',
    \ }

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
silent! colorscheme nord
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

if has('win32')
  let g:clang_path = "C:/Program Files/LLVM"
endif

let g:LanguageClient_serverCommands = {
\ 'cpp': [g:clang_path . '/bin/clangd', '--background-index'],
\ 'c': [g:clang_path . '/bin/clangd', '--background-index'],
\ }
let g:LanguageClient_loadSettings = 1
let g:LanguageClient_settingsPath = $HOME.'/.config/nvim/settings.json'
" Limits how often the LanguageClient talks to the
" server, so it reduces CPU load and flashing.
let g:LanguageClient_changeThrottle = 0.5
let g:LanguageClient_diagnosticsEnable = 0
nnoremap <leader>ty :call LanguageClient#textDocument_hover()<CR>
nnoremap <leader>rf :call LanguageClient#textDocument_references()<CR>
nnoremap <leader>rj :call LanguageClient#textDocument_definition()<CR>
nnoremap <leader>rw :call LanguageClient#textDocument_rename()<CR>
nnoremap <leader>ds :call LanguageClient#textDocument_documentSymbol()<CR>
nnoremap <leader>cm :call LanguageClient_contextMenu()<CR>

" ALE configuration
let g:ale_linters = {
\   'cpp': ['clangtidy'],
\   'c': ['clangtidy'],
\}
let g:ale_cpp_clangtidy_executable = g:clang_path . '/bin/clang-tidy'
let g:ale_c_clangtidy_executable = g:clang_path . '/bin/clang-tidy'
" Set up mapping to move between errors
nmap <silent> [w <Plug>(ale_previous_wrap)
nmap <silent> ]w <Plug>(ale_next_wrap)

" Key mappings for clang-format, to format source code.
" map <expr> allows expansion of the variable for the
" clang path.
map <expr> <leader>f ":py3f " . g:clang_path . "/share/clang/clang-format.py<CR>"

" Set up keyboard shortbuts for fzf, the fuzzy finder
nnoremap <leader>z :Files<CR>
nnoremap <leader><Tab> :Buffers<CR>
nnoremap <leader>h :History:<CR>
nnoremap <leader>/ :History/<CR>
nnoremap <leader>l :BLines<CR>
nnoremap <leader>bc :BCommits<CR>
" A mapping to search using ag:
nnoremap <leader>ag :Ag<space>
" A command to enable case-sensitive search with Ag:
command! -bang -nargs=* Ags
  \ call fzf#vim#grep('ag --nogroup --column --color -s '.shellescape(<q-args>), 0, <bang>0)
" A mapping to do case-insensitive search using ag:
nnoremap <leader>as :Ags<space>
" A command that will search for the word under the cursor:
command! -nargs=* -bang AgIW
  \ call fzf#vim#grep(
  \   'ag --nogroup --column --color --smart-case '.shellescape(expand('<cword>')), 1,
  \   fzf#vim#with_preview(), <bang>0)
" A mapping for the above command
nnoremap <leader>w :AgIW<CR>
" Set the fzf popup layout
let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.6 } }

" Use The Silver Searcher for grep, if available:
if executable('ag')
  " Use ag over grep
  set grepprg=ag\ --nogroup\ --nocolor
endif

" For vim-cpp-enhanced-highlight, turn on highlighting of class scope:
let g:cpp_class_scope_highlight = 1
" And highlight member variables:
let g:cpp_member_variable_highlight = 1

" Turn off prompting to load .ycm_extra_conf.py:
let g:ycm_confirm_extra_conf = 0
nnoremap <F2> :YcmCompleter GoTo<CR>
" Map to apply quick fix:
nnoremap <F3> :YcmCompleter FixIt<CR>
" Let clangd fully control code completion
" let g:ycm_clangd_uses_ycmd_caching = 0
let g:ycm_clangd_args = ['-log=verbose', '--pretty', '--background-index', '--completion-style=detailed']

" Ultisnips config:
" Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
let g:UltiSnipsExpandTrigger="<c-j>"
let g:UltiSnipsJumpForwardTrigger="<c-j>"
let g:UltiSnipsJumpBackwardTrigger="<c-n>"

" Ensure the status line is always displayed:
set laststatus=2

let g:lightline = {}
let g:lightline.colorscheme = 'nord'

" Add linting info to the status line:
let g:lightline.component_expand = {
        \  'linter_checking': 'lightline#ale#checking',
        \  'linter_warnings': 'lightline#ale#warnings',
        \  'linter_errors': 'lightline#ale#errors',
        \  'linter_ok': 'lightline#ale#ok',
        \ }
let g:lightline.component_type = {
        \     'linter_checking': 'right',
        \     'linter_warnings': 'warning',
        \     'linter_errors': 'error',
        \     'linter_ok': 'right',
        \ }

let g:lightline.active = {
        \   'left': [ [ 'mode', 'paste' ],
        \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ],
        \   'right': [ [ 'linter_checking', 'linter_errors', 'linter_warnings', 'linter_ok' ],
        \              [ 'lineinfo' ],
        \            [ 'obsession', 'percent' ],
        \            [ 'fileformat', 'fileencoding', 'filetype' ] ] 
        \ }
let g:lightline.component = {
        \   'lineinfo': ' %3l:%-2v'
        \ }
let g:lightline.component_function = {
        \   'readonly': 'LightlineReadonly',
        \   'gitbranch': 'LightlineFugitive',
        \   'obsession': 'ObsessionStatus',
        \ }
let g:lightline.separator = { 'left': '', 'right': '' }
let g:lightline.subseparator = { 'left': '', 'right': '' }
function! LightlineReadonly()
        return &readonly ? '' : ''
endfunction
" This function is taken from vim-airline, to shorten
" the branch name when appropriate.
function! LightlineShorten(text, winwidth, minwidth, ...)
  if winwidth(0) < a:winwidth && len(split(a:text, '\zs')) > a:minwidth
    if get(a:000, 0, 0)
      " shorten from tail
      return '…'.matchstr(a:text, '.\{'.a:minwidth.'}$')
    else
      " shorten from beginning of string
      return matchstr(a:text, '^.\{'.a:minwidth.'}').'…'
    endif
  else
    return a:text
  endif
endfunction
function! LightlineFugitive()
        if exists('*FugitiveHead')
                let branch = FugitiveHead(7)
                let branch = branch !=# '' ? ' '.branch : ''
                return LightlineShorten(branch, 120, 15)
        endif
        return ''
endfunction

" Function, courtesy of Marc Gallant, to make it easy
" to switch between C and C++ header and source files
" using fzf.
function! FZFSameName(sink, pre_command, post_command)
    let current_file_no_extension = expand("%:t:r")
    let current_file_with_extension = expand("%:t")
    execute a:pre_command
    call fzf#run(fzf#wrap({
          \ 'source': 'find -name ' . current_file_no_extension . '.* | grep -Ev *' . current_file_with_extension . '$',
          \ 'options': '--select-1', 'sink': a:sink}))
    execute a:post_command
endfunction
nnoremap <leader>of :call FZFSameName('e', '', '')<CR>
nnoremap <leader>oh :call FZFSameName('e', 'wincmd h', '')<CR>
nnoremap <leader>ol :call FZFSameName('e', 'wincmd l', '')<CR>
nnoremap <leader>ok :call FZFSameName('e', 'wincmd k', '')<CR>
nnoremap <leader>oj :call FZFSameName('e', 'wincmd j', '')<CR>
nnoremap <leader>oH :call FZFSameName('leftabove vsplit', '', 'wincmd h')<CR>
nnoremap <leader>oL :call FZFSameName('rightbelow vsplit', '', 'wincmd l')<CR>
nnoremap <leader>oK :call FZFSameName('leftabove split', '', 'wincmd k')<CR>
nnoremap <leader>oJ :call FZFSameName('rightbelow split', '', 'wincmd j')<CR>

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
