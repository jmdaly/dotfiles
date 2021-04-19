scriptencoding utf-8
" Use space as leader:
let mapleader = "\<Space>"

lua require('plugins')
lua require('completion')
lua require('lsp')
lua require('jmdaly.config')

" Some colour schemes clear the LSP highlight groups, so we set them back up here:
lua require('vim.lsp.diagnostic')._define_default_signs_and_highlights()

" Enable true colour support:
set termguicolors

" Add to the runtime path so that custom
" snippets can be found:
set runtimepath+=~/dotfiles

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
nnoremap <silent> <leader>m  <cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>

" Various mappings to open the corresponding header/source file in a new split
nnoremap <silent> <leader>of <cmd>ClangdSwitchSourceHeader<CR>
nnoremap <silent> <leader>oh <cmd>vsp<CR><cmd>ClangdSwitchSourceHeader<CR>
nnoremap <silent> <leader>oj <cmd>below sp<CR><cmd>ClangdSwitchSourceHeader<CR>
nnoremap <silent> <leader>ok <cmd>sp<CR><cmd>ClangdSwitchSourceHeader<CR>
nnoremap <silent> <leader>ol <cmd>below vsp<CR><cmd>ClangdSwitchSourceHeader<CR>

nnoremap <silent> [z         <cmd>lua vim.lsp.diagnostic.goto_prev()<CR>
nnoremap <silent> ]z         <cmd>lua vim.lsp.diagnostic.goto_next()<CR>

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

" Mappings for formatting code
augroup FILE_FORMATTING
  autocmd FileType cpp    map <buffer> <expr> <leader>f ":py3f " . g:clang_path . "/share/clang/clang-format.py<CR>"
  autocmd FileType c      map <buffer> <expr> <leader>f ":py3f " . g:clang_path . "/share/clang/clang-format.py<CR>"
  autocmd FileType python nnoremap <buffer> <leader>f :Black<CR>
augroup END

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
augroup end

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
