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
Plug 'ihacklog/HiCursorWords' " Plug to highlight the variable under the cursor:
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

Plug 'prabirshrestha/async.vim'
Plug 'prabirshrestha/vim-lsp'

" Plug 'autozimu/LanguageClient-neovim', {
"     \ 'branch': 'next',
"     \ 'do': 'bash install.sh',
"     \ }

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

" let g:LanguageClient_serverCommands = {
" \ 'cpp': ['cquery', '--log-file=/tmp/cq.log']
" \ }
" let g:LanguageClient_loadSettings = 1
" let g:LanguageClient_settingsPath = '/home/jdaly/.config/nvim/settings.json'
" nnoremap <leader>ty :call LanguageClient#textDocument_hover()<CR>
" nnoremap <leader>rf :call LanguageClient#textDocument_references()<CR>
" nnoremap <leader>rj :call LanguageClient#textDocument_definition()<CR>
" nnoremap <leader>rw :call LanguageClient#textDocument_rename()<CR>

if executable('cquery')
   au User lsp_setup call lsp#register_server({
      \ 'name': 'cquery',
      \ 'cmd': {server_info->['cquery']},
      \ 'root_uri': {server_info->lsp#utils#path_to_uri(lsp#utils#find_nearest_parent_file_directory(lsp#utils#get_buffer_path(), 'compile_commands.json'))},
      \ 'initialization_options': { 'cacheDirectory': '/tmp/cquery' },
      \ 'whitelist': ['c', 'cpp', 'objc', 'objcpp'],
      \ })
endif
let g:lsp_log_verbose = 1
let g:lsp_log_file = '/tmp/vim-lsp.log'
let g:lsp_signs_enabled = 1         " enable signs
nnoremap <leader>ty :LspHover<CR>
nnoremap <leader>rf :LspReferences<CR>
nnoremap <leader>rj :LspDefinition<CR>
nnoremap <leader>rw :LspRename<CR>

" Location of clang
let g:clang_path = "/opt/llvm"

" ALE configuration
let g:ale_linters = {
\   'cpp': ['clangtidy'],
\}
let g:ale_cpp_clangtidy_checks = ['clang-analyzer-*', 'modernize-*', 'performance-*', 'readability-*', 'google-readability-casting']
let g:ale_cpp_clangtidy_executable = g:clang_path . '/bin/clang-tidy'
" Set up mapping to move between errors
nmap <silent> [w <Plug>(ale_previous_wrap)
nmap <silent> ]w <Plug>(ale_next_wrap)

" Key mappings for clang-format, to format source code.
" map <expr> allows expansion of the variable for the
" clang path.
map <expr> <leader>f ":pyf " . g:clang_path . "/share/clang/clang-format.py<CR>"

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

" Ultisnips config:
" Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
let g:UltiSnipsExpandTrigger="<c-j>"
let g:UltiSnipsJumpForwardTrigger="<c-j>"
let g:UltiSnipsJumpBackwardTrigger="<c-n>"

" Ensure the status line is always displayed:
set laststatus=2

let g:lightline = {
        \ 'colorscheme': 'nord',
        \ 'active': {
        \   'left': [ [ 'mode', 'paste' ],
        \             [ 'fugitive', 'readonly', 'filename', 'modified' ] ],
        \   'right': [ [ 'lineinfo' ],
        \            [ 'obsession', 'percent' ],
        \            [ 'fileformat', 'fileencoding', 'filetype' ] ] 
        \ },
        \ 'component': {
        \   'lineinfo': ' %3l:%-2v',
        \ },
        \ 'component_function': {
        \   'readonly': 'LightlineReadonly',
        \   'fugitive': 'LightlineFugitive',
        \   'obsession': 'ObsessionStatus',
        \ },
        \ 'separator': { 'left': '', 'right': '' },
        \ 'subseparator': { 'left': '', 'right': '' }
        \ }
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
        if exists('*fugitive#head')
                let branch = fugitive#head(7)
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
