scriptencoding utf-8
" Use space as leader:
let mapleader = "\<Space>"

" Load filetype plugins. This has to come before any autocmds
" that do things like change the commenstring, so we keep it near
" the top of the file.
filetype plugin on

lua require('plugins')
lua require('completion')
lua require('lsp')
lua require('jmdaly.config')

" Enable true colour support:
set termguicolors

let g:material_style = 'palenight'
let g:gruvbox_material_palette = 'mix'
colorscheme gruvbox-material

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

" Add a mapping to escape out of terminal mode:
tnoremap <Leader>e <C-\><C-n>

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
nnoremap <silent> <leader>m  <cmd>lua vim.diagnostic.open_float()<CR>

" Various mappings to open the corresponding header/source file in a new split
nnoremap <silent> <leader>of <cmd>ClangdSwitchSourceHeader<CR>
nnoremap <silent> <leader>oh <cmd>vsp<CR><cmd>ClangdSwitchSourceHeader<CR>
nnoremap <silent> <leader>oj <cmd>below sp<CR><cmd>ClangdSwitchSourceHeader<CR>
nnoremap <silent> <leader>ok <cmd>sp<CR><cmd>ClangdSwitchSourceHeader<CR>
nnoremap <silent> <leader>ol <cmd>below vsp<CR><cmd>ClangdSwitchSourceHeader<CR>

nnoremap <silent> [z         <cmd>lua vim.diagnostic.goto_prev()<CR>
nnoremap <silent> ]z         <cmd>lua vim.diagnostic.goto_next()<CR>

" DAP debug mappings
nnoremap <silent> <leader>dc :lua require'dap'.continue()<CR>
nnoremap <silent> <leader>do :lua require'dap'.step_over()<CR>
nnoremap <silent> <leader>di :lua require'dap'.step_into()<CR>
nnoremap <silent> <leader>br :lua require'dap'.toggle_breakpoint()<CR>
nnoremap <silent> <leader>dr :lua require'dap'.repl.open()<CR>
nnoremap <silent> <leader>dl :lua require'dap'.run_last()<CR>
nnoremap <silent> <leader>dh :lua require'dap.ui.variables'.hover()<CR>

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
\   'python': ['pyls', 'flake8'],
\   'rust': ['cargo', 'analyzer'],
\}
let g:ale_cpp_clangtidy_executable = g:clang_path . '/bin/clang-tidy'
let g:ale_cpp_clangtidy_extra_options = '-header-filter=.*'

let g:ale_c_clangtidy_executable = g:clang_path . '/bin/clang-tidy'
let g:ale_c_clangtidy_extra_options = '-header-filter=.*'
" Set up mapping to move between errors
nmap <silent> [w <Plug>(ale_previous_wrap)
nmap <silent> ]w <Plug>(ale_next_wrap)

" Key mappings for clang-format, to format source code.
" map <expr> allows expansion of the variable for the
" clang path.
let g:clang_format_path = g:clang_path . '/bin/clang-format'

" Mappings for formatting code
augroup FILE_FORMATTING
  autocmd FileType cpp    map <buffer> <expr> <leader>f ":py3f " . g:clang_path . "/share/clang/clang-format.py<CR>"
  autocmd FileType c      map <buffer> <expr> <leader>f ":py3f " . g:clang_path . "/share/clang/clang-format.py<CR>"
  autocmd FileType python nnoremap <buffer> <leader>f :Black<CR>
  autocmd FileType rust   nnoremap <buffer> <leader>f <cmd>lua vim.lsp.buf.format { async = true }<CR>
augroup END

" Set up keyboard shortbuts for fzf, the fuzzy finder
nnoremap <leader>z :Files<CR>
nnoremap <leader><Tab> :Buffers<CR>
nnoremap <leader>h :History:<CR>
nnoremap <leader>/ :History/<CR>
nnoremap <leader>l :BLines<CR>
nnoremap <leader>bc :BCommits<CR>
" A mapping to search using ag:
nnoremap <leader>rg :Rg<space>
" A command that will search for the word under the cursor:
command! -nargs=* -bang RgIW
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always --smart-case '.shellescape(expand('<cword>')), 1,
  \   fzf#vim#with_preview(), <bang>0)
" A mapping for the above command
nnoremap <leader>w :RgIW<CR>
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

" vim-vsnip key mappings
" Expand or jump
imap <expr> <C-j>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-j>'
smap <expr> <C-j>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-j>'

" Jump backward
imap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<C-n>'
smap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<C-n>'

" " Select or cut text to use as $TM_SELECTED_TEXT in the next snippet.
" " See https://github.com/hrsh7th/vim-vsnip/pull/50
" nmap        s   <Plug>(vsnip-select-text)
" xmap        s   <Plug>(vsnip-select-text)
" nmap        S   <Plug>(vsnip-cut-text)
" xmap        S   <Plug>(vsnip-cut-text)

" Ensure the status line is always displayed:
set laststatus=2

" Set the comment string for certain filetypes to
" double slashes (used for vim-commentary):
augroup FTOptions 
    autocmd!
    autocmd FileType c,cpp,cs,java          setlocal commentstring=//\ %s
    autocmd FileType cmake                  setlocal commentstring=#\ %s
    autocmd FileType matlab                 setlocal commentstring=%\ %s
augroup END

" Configure some unconventional filetypes
augroup filetypes
    autocmd BufNewFile,BufRead Jenkinsfile*        setlocal filetype=groovy
    autocmd BufNewFile,BufRead Dockerfile*         setlocal filetype=dockerfile
augroup end

" Mapping to close the file in the current buffer:
nnoremap <leader>q :Sayonara<cr>
nnoremap <leader>Q :Sayonara!<cr>

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
