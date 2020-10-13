" Use space as leader:
let mapleader = "\<Space>"

call plug#begin('~/.vim/plugged')

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

Plug 'neovim/nvim-lspconfig' " Configurations for neovim's language client
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'Shougo/deoplete-lsp' " deoplete source for the neovim language server
Plug 'nvim-lua/diagnostic-nvim'

Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-lua/telescope.nvim'

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
set runtimepath+=~/dotfiles

" Deoplete setup
let g:deoplete#enable_at_startup = 1
" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
inoremap <silent><expr><S-TAB>  pumvisible() ? "\<C-p>" : "\<TAB>"
" Use the full fuzzy matcher, like YCM
call deoplete#custom#source('_', 'matchers', ['matcher_full_fuzzy'])

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
let g:clang_path = '/opt/llvm'

if has('win32')
  let g:clang_path = 'C:/Program Files/LLVM'
endif

" Set up the built-in language client
lua <<EOF
local nvim_lsp = require'nvim_lsp'
-- We check if a language server is available before setting it up.
-- Otherwise, we'll get errors when loading files.

-- Set up clangd, also to use nvim-diagnostic
nvim_lsp.clangd.setup{
  cmd = { vim.g.clang_path .. "/bin/clangd", "--background-index" },
  on_attach=require'diagnostic'.on_attach
}

if 1 == vim.fn.executable("cmake-language-server") then
  nvim_lsp.cmake.setup{}
end

if 1 == vim.fn.executable("pyls") then
  nvim_lsp.pyls.setup{on_attach=require'diagnostic'.on_attach}
end
EOF

augroup lsp
  autocmd!
  " Use LSP omni-completion in C and C++ files.
  autocmd Filetype c setlocal omnifunc=v:lua.vim.lsp.omnifunc
  autocmd Filetype cpp setlocal omnifunc=v:lua.vim.lsp.omnifunc
augroup end

nnoremap <silent> <leader>rd <cmd>lua vim.lsp.buf.declaration()<CR>
nnoremap <silent> <leader>rj <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> <leader>ty <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> <leader>rk <cmd>lua vim.lsp.buf.signature_help()<CR>
nnoremap <silent> <leader>rf <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <silent> <leader>ds <cmd>lua vim.lsp.buf.document_symbol()<CR>
nnoremap <silent> <leader>rw <cmd>lua vim.lsp.buf.rename()<CR>
nnoremap <silent> <leader>k  <cmd>lua vim.lsp.buf.code_action()<CR>
nnoremap <silent> <leader>m  <cmd>lua vim.lsp.util.show_line_diagnostics()<CR>

" Various mappings to open the corresponding header/source file in a new split
nnoremap <silent> <leader>of <cmd>ClangdSwitchSourceHeader<CR>
nnoremap <silent> <leader>oh <cmd>vsp<CR><cmd>ClangdSwitchSourceHeader<CR>
nnoremap <silent> <leader>oj <cmd>below sp<CR><cmd>ClangdSwitchSourceHeader<CR>
nnoremap <silent> <leader>ok <cmd>sp<CR><cmd>ClangdSwitchSourceHeader<CR>
nnoremap <silent> <leader>ol <cmd>below vsp<CR><cmd>ClangdSwitchSourceHeader<CR>

nnoremap <silent> [z         <cmd>PrevDiagnosticCycle<CR>
nnoremap <silent> ]z         <cmd>NextDiagnosticCycle<CR>

" Set up Telescope
" nnoremap <leader>rf <cmd>lua require'telescope.builtin'.lsp_references{}<CR>
" nnoremap <Leader>z <cmd>lua require'telescope.builtin'.find_files{ find_command = { "ag", "-g", "" } }<CR>
" nnoremap <Leader>h <cmd>lua require'telescope.builtin'.command_history{}<CR>
" nnoremap <Leader><Tab> <cmd>lua require'telescope.builtin'.buffers{}<CR>

" pc-lint error format and make configuration.
let g:pclint_path = $HOME.'/pclint/linux'
if isdirectory(g:pclint_path)
  let &makeprg = g:pclint_path . '/pclp64_linux ' . g:pclint_path . '/lnt/au-misra3.lnt -wlib\(4\) -wlib\(1\) -h1 -width\(0,0\) -"format=\%(\%f:\%l:\%C \%) \%t \%n: \%m" co-gcc.lnt project_includes.lnt %'
  set errorformat+=%f:%l:%c\ \ warning\ %n:\ %m
  set errorformat+=%f:%l:%c\ \ error\ %n:\ %m
  set errorformat+=%f:%l:%c\ \ supplemental\ %n:\ %m
  set errorformat+=%f:%l:%c\ \ info\ %n:\ %m
  let g:ale_c_pclint_executable = g:pclint_path . '/pclp64_linux'
  let g:ale_c_pclint_options =  g:pclint_path . '/lnt/au-misra3.lnt -wlib\(4\) -wlib\(1\) co-gcc.lnt project_includes.lnt'
endif

" ALE configuration
let g:ale_linters = {
\   'cpp': ['clangtidy'],
\   'c': ['clangtidy', 'pclint'],
\}
let g:ale_cpp_clangtidy_executable = g:clang_path . '/bin/clang-tidy'
let g:ale_c_clangtidy_executable = g:clang_path . '/bin/clang-tidy'
" Set up mapping to move between errors
nmap <silent> [w <Plug>(ale_previous_wrap)
nmap <silent> ]w <Plug>(ale_next_wrap)

" Key mappings for clang-format, to format source code.
" map <expr> allows expansion of the variable for the
" clang path.
let g:clang_format_path = g:clang_path . '/bin/clang-format'
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

" Ultisnips config:
" Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
let g:UltiSnipsExpandTrigger='<c-j>'
let g:UltiSnipsJumpForwardTrigger='<c-j>'
let g:UltiSnipsJumpBackwardTrigger='<c-n>'

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

" Set the comment string for certain filetypes to
" double slashes (used for vim-commentary):
augroup FTOptions 
    autocmd!
    autocmd FileType c,cpp,cs,java          setlocal commentstring=//\ %s
    autocmd FileType cmake                  setlocal commentstring=#\ %s
    autocmd FileType matlab                 setlocal commentstring=%\ %s
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
nnoremap <leader>gs :Git<cr>
nnoremap <leader>gd :Gdiffsplit<cr>
nnoremap <leader>gg :Gdiffsplit 
nnoremap <leader>gm :Gdiffsplit master<cr>
nnoremap <leader>gb :Git blame<cr>
