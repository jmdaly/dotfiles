" TODO Add default files ( see https://unix.stackexchange.com/a/597550/100689
" ) if in vim8

" Used for host detection
let hostname = substitute(system('hostname'), '\n', '', '')
let hostos   = substitute(system('uname -o'), '\n', '', '')
let hostkv   = substitute(system('uname -v'), '\n', '', '')

" Set up some paths that might be changed later based on the platform.  These
" are defaulted to their linux path
let g:dotfiles   = $HOME . '/dotfiles'
let g:env_folder = $HOME . '/.virtualenvs/default'

if matchstr(hostname, 'dena') ==? 'dena' || hostname ==? 'sahand'
   let domain='school'
" Can probably get rid of this...
elseif $TRUE_HOST !=? ''
   let domain='ec'
elseif match(hostname, 'siteground') >= 0
   " Siteground is an exception because it uses vim 7.0
   let domain='siteground'
elseif match(hostname, 'khea') >= 0
   let domain='home'
else
   let domain='any'
endif
" echo 'Using domain ' . domain . ', hostname=' . hostname

if match($HOME, 'com.termux') >= 0
   let is_termux=1
else
   let is_termux=0
endif

let is_winbash=0
let is_win=0
if has('unix')
   if matchstr(hostkv, 'icrosoft') == 'icrosoft'
      let is_winbash=1
   endif
endif
if has('win32')||has('win32unix')||1==is_winbash
   let is_win=1
   if ''==$HOME && 0==is_winbash
      let $WINHOME_WIN     = 'c:/users/' . $USERNAME
      let g:dotfiles   = $WINHOME_WIN . '/dotfiles'
      let g:env_folder = $WINHOME_WIN . '/.virtualenvs/default'
   endif
endif

let g:dein_plugin = g:dotfiles . '/bundles/dein/repos/github.com/Shougo/dein.vim'
if isdirectory(g:dein_plugin)
   let g:dein_exists = 1
else
   let g:dein_exists = 0
endif

if has('nvim') && isdirectory(g:env_folder)
   if has('win32')
      let g:python_host_prog  = expand(g:env_folder . '/Scripts/python.exe')
      let g:python3_host_prog = g:python_host_prog
   else
      let g:python_host_prog  = expand(g:env_folder . '/bin/python')
      let g:python3_host_prog = g:python_host_prog . '3'
   endif

   if empty(glob(g:python_host_prog))
      echom 'Could not find g:python_host_prog = '. g:python_host_prog
      let g:python_host_prog = trim(system('which python3'))
      echom 'Setting g:python_host_prog = '. g:python_host_prog
   endif
   if empty(glob(g:python3_host_prog))
      echom 'Could not find g:python3_host_prog = '. g:python3_host_prog
      let g:python3_host_prog = trim(system('which python3'))
      echom 'Setting g:python3_host_prog = '. g:python3_host_prog
   endif
endif


" Configure some unconventional filetypes
augroup filetypes
   " EnvCan filetypes
   au BufNewFile,BufRead *.ftn90,*.cdk*,.nml setlocal ft=fortran
   au BufNewFile,BufRead *recettes,*cibles   setlocal ft=make
   au BufNewFile,BufRead *.spi               setlocal ft=tcl
   au BufNewFile,BufRead .exper_cour         setlocal ft=sh
   au BufNewFile,BufRead Common_Compiler*    setlocal ft=sh
   au BufNewFile,BufRead *.dot               setlocal ft=zsh

   " NTC only-rules (so far)
   au BufNewFile,BufRead *.lcm               setlocal ft=c
   au BufNewFile,BufRead */Wt/W*             setlocal ft=cpp
   au BufNewFile,BufRead *.qml               setlocal ft=qml
   au BufNewFile,BufRead *.qrc               setlocal ft=xml
   au BufNewFile,BufRead *.vert,*.geo,*.frag setlocal ft=glsl

   au BufNewFile,BufRead *.html.base         setlocal ft=html
   au BufNewFile,BufRead *.module            setlocal ft=php
   au BufNewFile,BufRead *.gs                setlocal ft=javascript
   au BufNewFile,BufRead *.json              setlocal ft=json
   au BufNewFile,BufRead *.json.in           setlocal ft=json
   au BufNewFile,BufRead *.kt                setlocal ft=kotlin

   " Ford
   au BufNewFile,BufRead *.fidl,*.fdepl      setlocal ft=fidl
   au BufNewFile,BufRead api/current.txt     setlocal ft=java
   au BufNewFile,BufRead */Config.in         setlocal ft=make
   au BufNewFile,BufRead */Config.in.host    setlocal ft=make

   au BufNewFile,BufRead Dockerfile*         setlocal ft=dockerfile
   au BufNewFile,BufRead */modulefiles/**    setlocal ft=tcl
   au BufNewFile,BufRead */.conan/profiles/* setlocal ft=sh
   au BufNewFile,BufRead *.fs                setlocal ft=sh
   au BufNewFile,BufRead */aos/*.rc          setlocal ft=sh
   au BufNewFile,BufRead *.envrc             setlocal ft=sh
   au BufNewFile,BufRead .jdbrc              setlocal ft=jdb
   au BufNewFile,BufRead .clangd             setlocal ft=yaml
   au BufNewFile,BufRead .tmpl               setlocal ft=tmpl
augroup end

augroup whitespace
   autocmd!
   autocmd FileType cs              setlocal ff=dos
   autocmd FileType yaml,json       setlocal ts=2 sw=2 sts=2 expandtab ai
   autocmd FileType markdown        setlocal spell
   autocmd FileType tex             setlocal spell
   autocmd FileType xml             setlocal ts=2 sw=2 sts=2 expandtab ai
   autocmd FileType cmake           setlocal ts=2 sw=2 sts=2 expandtab ai
   autocmd FileType make            setlocal ts=8 sw=8 sts=8 noet ai
   autocmd FileType fidl            setlocal ts=2 sw=2 sts=2 expandtab ai
   autocmd FileType aidl            setlocal ts=2 sw=2 sts=2 expandtab ai
   autocmd FileType gitcommit       setlocal ts=2 sw=2 sts=2 expandtab spell | syntax off
   autocmd FileType groovy          setlocal ts=4 sw=4 sts=4 expandtab
   autocmd FileType lua             setlocal ts=2 sw=2 sts=2 expandtab
   autocmd FileType cs,cpp,c,sh,ps1,kotlin,java setlocal ts=4 sw=4 sts=4 expandtab
   autocmd FileType bzl,javascript  setlocal ts=4 sw=4 sts=4 expandtab
augroup END

" Set the comment string for certain filetypes to
" double slashes (used for vim-commentary):
augroup FTOptions
    autocmd!
    autocmd FileType c,cpp,cs,java,bzl,javascript setlocal commentstring=//\ %s
    autocmd FileType sh,jdb,cmake                 setlocal commentstring=#\ %s
    autocmd FileType tmpl                         setlocal commentstring=##\ %s
augroup END

augroup SHORTCUTS
   " Comment out parameter
   autocmd FileType c,cpp noremap wcc :exec 's/\(\<'.expand('<cword>') .'\>\)/\/* \1 *\//g'<CR>
augroup END

set nocompatible  " Dein also wants this

" Enable true colour support:
if !exists('g:gui_oni') && has('termguicolors')
  set termguicolors
endif

" if
"    " Colour coding nests
"    Plug 'luochen1990/rainbow'
"    let g:rainbow_active = 1 "0 if you want to enable it later via :RainbowToggle
" endif

" TODO try packer instead of dein: https://github.com/wbthomason/packer.nvim
if g:dein_exists && (v:version >= 800 || has('nvim'))
   let &runtimepath.=',' . g:dein_plugin

   " Required:
   if dein#load_state(string(g:dotfiles . '/bundles/dein'))
      call dein#begin(g:dotfiles . '/bundles/dein')

      " Let dein manage dein
      call dein#add(g:dotfiles . '/bundles/dein/repos/github.com/Shougo/dein.vim')

      " Lazy-load on C++
      call dein#add('vim-scripts/DoxygenToolkit.vim', {'on_ft': ['c', 'cpp', 'h', 'hpp']})

      " Lazy-load on PHP
      " call dein#add('shawncplus/phpcomplete.vim', {'on_ft': ['php']})

      " Lazy-load on python
      call dein#add('Hdima/python-syntax', {'on_ft': ['py']})

      " fugitive - a Git wrapper for vim. Also allows current
      call dein#add('tpope/vim-fugitive')
      set diffopt+=vertical

      if has('unix')
         call dein#add('SirVer/ultisnips')
         call dein#add('honza/vim-snippets')
      endif

      " call dein#add('majutsushi/tagbar')

      " Plugin to change the current directory to a project's root (so, look for
      " .git or something)
      call dein#add('airblade/vim-rooter')

      " Adding this so I can search/replace and preserve letter case
      call dein#add('tpope/vim-abolish')

      " Used for navigating the quickfix window better.  Recommended by fugitive
      call dein#add('tpope/vim-unimpaired')

      " This should improve Git Fugitive and Git Gutter
      call dein#add('tmux-plugins/vim-tmux-focus-events')

      " Highlighting for tmux
      call dein#add('tmux-plugins/vim-tmux')

      " Plug to assist with commenting out blocks of text:
      call dein#add('tpope/vim-commentary')

      " Tabular, align equals
      call dein#add('godlygeek/tabular')

      " Show markers
      call dein#add('kshenoy/vim-signature')

      " A plugin for asynchronous linting while you type
      call dein#add('w0rp/ale', {'on_ft': ['cpp', 'c']})
      call dein#add('itchyny/lightline.vim')
      call dein#add('maximbaz/lightline-ale')

      call dein#add('airblade/vim-gitgutter')

      " Display trailing whitespace
      call dein#add('ntpeters/vim-better-whitespace')

      " call dein#add('editorconfig/editorconfig-vim')

      " Vim sugar for the UNIX shell commands that need it the most. Features include:
      " :Remove: Delete a buffer and the file on disk simultaneously.
      " :Unlink: Like :Remove, but keeps the now empty buffer.
      " :Move:   Rename a buffer and the file on disk simultaneously.
      " :Rename: Like :Move, but relative to the current file's containing directory.
      " :Chmod:  Change the permissions of the current file.
      " :Mkdir:  Create a directory, defaulting to the parent of the current file.
      " :Find:   Run find and load the results into the quickfix list.
      " :Locate: Run locate and load the results into the quickfix list.
      " :Wall:   Write every open window. Handy for kicking off tools like guard.
      " :SudoWrite: Write a privileged file with sudo.
      " :SudoEdit:  Edit a privileged file with sudo.
      call dein#add('tpope/vim-eunuch')

      if has('nvim')
         " Have vim reload a file if it has changed outside of vim:
         call dein#add('TheZoq2/neovim-auto-autoread')
      endif

      if !exists('g:gui_oni') && has('nvim') && is_termux==0
         call dein#add('vimlab/split-term.vim')

         call dein#add('neovim/nvim-lspconfig')
         call dein#add('hrsh7th/nvim-compe') " Autocompletion plugin
         call dein#add('kosayoda/nvim-lightbulb')
      endif

      " Syntax highlighting for kotlin
      call dein#add('udalov/kotlin-vim')

      call dein#add('tpope/vim-obsession')
      call dein#add('mhinz/vim-startify')
      call dein#add('szw/vim-maximizer')

      if has('unix') && !exists('g:gui_oni')
         " Install fzf, the fuzzy searcher (also loads Ultisnips)
         call dein#add('junegunn/fzf', { 'build': './install --all', 'merged': 0 })
         call dein#add('junegunn/fzf.vim', {'depends': 'fzf' })
         call dein#add('ojroques/nvim-lspfuzzy', {'depends': 'fzf' })
      endif

      call dein#add('PProvost/vim-ps1')

      " syntax highlighting for *.hal, *.bp, and *.rc files.
      call dein#add('https://github.ford.com/MRUSS100/aosp-vim-syntax.git')
      " call dein#add('rubberduck203/aosp-vim')

      call dein#add('kheaactua/vim-fzf-repo')

      "
      " Colourschemes
      call dein#add('altercation/vim-colors-solarized')
      call dein#add('kristijanhusak/vim-hybrid-material')
      call dein#add('atelierbram/vim-colors_duotones')
      call dein#add('atelierbram/vim-colors_atelier-schemes')

      " Other..
      call dein#add('rakr/vim-one')
      call dein#add('arcticicestudio/nord-vim')
      call dein#add('drewtempelmeyer/palenight.vim')
      call dein#add('morhetz/gruvbox')
      call dein#add('mhartington/oceanic-next')

      call dein#add('ayu-theme/ayu-vim')
      let ayucolor="mirage"

      " A bunch more...
      call dein#add('flazz/vim-colorschemes')

      call dein#add('kheaactua/vim-managecolor')
      "
      " /Colourschemes

     " Required:
     call dein#end() " On Windows, outputting No matching autocommands"
     call dein#save_state()
   endif

   " Required:
   filetype plugin indent on
   syntax enable

   " If you want to install not installed plugins on startup.
   if dein#check_install()
      call dein#install()
   endif

   "End dein Scripts-------------------------
endif

if executable('black')
  " Only load the plugin if the black executable is available, this is
  " to prevent errors on startup
  call dein#add('psf/black', { 'branch': 'stable' }) " A plugin to format Python code by calling black
endif

silent if g:dein_exists && dein#check_install('vim-managecolor') == 0
   let g:colo_search_path = g:dotfiles . '/bundles/dein'
   let g:colo_cache_file  = g:dotfiles . '/colos.json'
   colo hydrangea
   " colo flatland
   " colo argonaut
endif


""""""""""""""""""""" Git-Gutter """"""""""""""""""""""""
nmap ]h <Plug>GitGutterNextHunk
nmap [h <Plug>GitGutterPrevHunk
" stage the hunk with <Leader>hs or
" revert it with <Leader>hr.
""""""""""""""""""""" /Git-Gutter """"""""""""""""""""""""

""""""""""""""""""""" /vim-maximizer """"""""""""""""""""""""
nnoremap <silent> <leader>z :MaximizerToggle<CR>
vnoremap <silent> <leader>z :MaximizerToggle<CR>gv
inoremap <silent> <leader>z <C-o>:MaximizerToggle<CR>

nnoremap <silent> <C-w>z :MaximizerToggle<CR>
vnoremap <silent> <C-w>z :MaximizerToggle<CR>gv
inoremap <silent> <C-w>z <C-o>:MaximizerToggle<CR>
""""""""""""""""""""" /vim-maximizer """"""""""""""""""""""""

""""""""""""""""""""""" Lightline """"""""""""""""""""""""
let g:lightline = {
   \ 'colorscheme': 'one',
   \ 'component_function': {
   \   'filename': 'LightlineFilename',
   \ },
\ }

function! LightlineFilename()
   return &filetype ==# 'vimfiler' ? vimfiler#get_status_string() :
      \ &filetype ==# 'unite' ? unite#get_status_string() :
      \ &filetype ==# 'vimshell' ? vimshell#get_status_string() :
      \ expand('%:t') !=# '' ? @% : '[No Name]'
endfunction

let g:unite_force_overwrite_statusline = 0
let g:vimfiler_force_overwrite_statusline = 0
let g:vimshell_force_overwrite_statusline = 0
let g:lightline.separator = { 'left': '', 'right': '' }
let g:lightline.subseparator = { 'left': '', 'right': '' }
function! LightlineReadonly()
   return &readonly ? '' : ''
endfunction

"""""""""""""""""""""" /Lightline """"""""""""""""""""""""

"""""""""""""""""""""" nvim-compe """"""""""""""""""""""""
set completeopt=menuone,noselect
inoremap <silent><expr> <C-Space> compe#complete()
inoremap <silent><expr> <CR>      compe#confirm('<CR>')
inoremap <silent><expr> <C-e>     compe#close('<C-e>')
inoremap <silent><expr> <C-f>     compe#scroll({ 'delta': +4 })
inoremap <silent><expr> <C-d>     compe#scroll({ 'delta': -4 })
"""""""""""""""""""""" /nvim-compe """"""""""""""""""""""""

"""""""""""""""""""""" LSP """"""""""""""""""""""""
let g:clang_path = '/usr'

" Set up the built-in language client
lua <<EOF
local lspconfig = require'lspconfig'
-- We check if a language server is available before setting it up.
-- Otherwise, we'll get errors when loading files.

-- Set up clangd
lspconfig.clangd.setup{
   cmd = {
      vim.g.clang_path .. "/bin/clangd",
      "--background-index"
   }
}

if 1 == vim.fn.executable("cmake-language-server") then
   lspconfig.cmake.setup{}
end

if 1 == vim.fn.executable("kotlin-language-server") then
   require'lspconfig'.kotlin_language_server.setup{}
   -- Hack recommended at
   -- https://github.com/fwcd/kotlin-language-server/issues/284#issuecomment-817835261
   -- to get Kotlin to be able to find gradle when it's not at the root of the
   -- repo
   lspconfig.kotlin_language_server.setup{
      settings = {
         kotlin = {
            compiler = {
               jvm = {
                  target = "1.8";
               }
            };
         };
      }
   }
end

if 1 == vim.fn.executable("pyls") then
   lspconfig.pyls.setup{}
end

-- Configure the way code diagnostics are displayed
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
   vim.lsp.diagnostic.on_publish_diagnostics, {
      -- This will disable virtual text, like doing:
      -- let g:diagnostic_enable_virtual_text = 0
      virtual_text = false,

      -- This is similar to:
      -- let g:diagnostic_show_sign = 1
      -- To configure sign display,
      --  see: ":help vim.lsp.diagnostic.set_signs()"
      signs = true,

      -- This is similar to:
      -- "let g:diagnostic_insert_delay = 1"
      update_in_insert = false,
   }
)

--- Enable the lspfuzzy plugin
require('lspfuzzy').setup {}
EOF

if has('nvim-0.5')
   augroup lsp
     autocmd!
     autocmd Filetype c setlocal omnifunc=v:lua.vim.lsp.omnifunc
     autocmd Filetype cpp setlocal omnifunc=v:lua.vim.lsp.omnifunc
     autocmd Filetype cpp lua require('compe_config')
     autocmd Filetype python setlocal omnifunc=v:lua.vim.lsp.omnifunc
   augroup end
endif

nnoremap <silent> <leader>rd <cmd>lua vim.lsp.buf.declaration()<CR>
nnoremap <silent> <leader>rj <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> <leader>ty <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> <leader>rk <cmd>lua vim.lsp.buf.signature_help()<CR>
nnoremap <silent> <leader>rf <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <silent> <leader>ds <cmd>lua vim.lsp.buf.document_symbol()<CR>
nnoremap <silent> <leader>rw <cmd>lua vim.lsp.buf.rename()<CR>
nnoremap <silent> <leader>c  <cmd>lua vim.lsp.buf.code_action()<CR>
nnoremap <silent> <leader>m  <cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>
nnoremap <silent> <leader>el <cmd>lua print(vim.lsp.get_log_path())<CR>

" Various mappings to open the corresponding header/source file in a new split
nnoremap <silent> <leader>of <cmd>ClangdSwitchSourceHeader<CR>
nnoremap <silent> <leader>oh <cmd>vsp<CR><cmd>ClangdSwitchSourceHeader<CR>
nnoremap <silent> <leader>oj <cmd>below sp<CR><cmd>ClangdSwitchSourceHeader<CR>
nnoremap <silent> <leader>ok <cmd>sp<CR><cmd>ClangdSwitchSourceHeader<CR>
nnoremap <silent> <leader>ol <cmd>below vsp<CR><cmd>ClangdSwitchSourceHeader<CR>

nnoremap <silent> [z         <cmd>lua vim.lsp.diagnostic.goto_prev()<CR>
nnoremap <silent> ]z         <cmd>lua vim.lsp.diagnostic.goto_next()<CR>
"""""""""""""""""""""" /LSP """"""""""""""""""""""""


"""""""""""""""""""""""""""" ALE """""""""""""""""""""""""
silent if g:dein_exists && dein#check_install('ale') == 0
   let g:ale_linters = {
      \ 'cpp': ['clangtidy'],
      \ 'c': ['clangtidy'],
      \}
   let g:ale_fixers={
      \ 'cpp': ['clang-format'],
      \ '*': ['remove_trailing_lines', 'trim_whitespace'],
      \}

   " Set up mapping to move between errors
   nmap <silent> [w <Plug>(ale_previous_wrap)
   nmap <silent> ]w <Plug>(ale_next_wrap)

   " Run clang-format
   autocmd FileType c,cpp,h,hpp nnoremap <buffer><Leader>fu :ALEFix<CR>
endif
""""""""""""""""""""""""""" /ALE """""""""""""""""""""""""


" For vim-cpp-enhanced-highlight, turn on highlighting of class scope:
let g:cpp_class_scope_highlight = 1


" Have vim reload a file if it has changed outside
" of vim:
if !has('nvim')
   set autoread
endif


"""""""""""""""""""" Ultisnips config """"""""""""""""""""""
" Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
silent if g:dein_exists && dein#check_install('ultisnips') == 0
   let g:UltiSnipsExpandTrigger='<c-j>'
   let g:UltiSnipsJumpForwardTrigger='<c-j>'
   let g:UltiSnipsJumpBackwardTrigger='<c-n>'

   " If you want :UltiSnipsEdit to split your window.
   let g:UltiSnipsEditSplit='vertical'

   " Add to the runtime path so that custom
   " snippets can be found:
   let &rtp .= ','.expand(g:dotfiles)
endif
""""""""""""""""""" /Ultisnips config """"""""""""""""""""""


"""""""""""""""""""" rooter config """"""""""""""""""""""
silent if g:dein_exists && dein#check_install('vim-rooter') == 0
   " Stop printing the cwd on write
   let rooter_silent_chdir=1
   let g:rooter_patterns = ['.git', '_darcs', '.hg', '.bzr', '.svn']
endif
""""""""""""""""""" /rooter config """"""""""""""""""""""

" """"""""""""""""" nvim-compe """""""""""""""""""
inoremap <silent><expr> <C-Space> compe#complete()
inoremap <silent><expr> <CR>      compe#confirm('<CR>')
inoremap <silent><expr> <C-e>     compe#close('<C-e>')
inoremap <silent><expr> <C-f>     compe#scroll({ 'delta': +4 })
inoremap <silent><expr> <C-d>     compe#scroll({ 'delta': -4 })
" """""""""""""""" /nvim-compe """""""""""""""""""

" """""""""""""""" Rainbow (foldering) """""""""""""""""""
"    let g:rainbow_conf = {
"    \   'guifgs': ['royalblue3', 'darkorange3', 'seagreen3', 'firebrick'],
"    \   'ctermfgs': ['lightblue', 'lightyellow', 'lightcyan', 'lightmagenta'],
"    \   'operators': '_,_',
"    \   'parentheses': ['start=/(/ end=/)/ fold', 'start=/\[/ end=/\]/ fold', 'start=/{/ end=/}/ fold'],
"    \   'separately': {
"    \      '*': {},
"    \      'tex': {
"    \         'parentheses': ['start=/(/ end=/)/', 'start=/\[/ end=/\]/'],
"    \      },
"    \      'cpp': {
"    \         'guifgs': ['royalblue3', 'darkorange3', 'seagreen3', 'firebrick', 'darkorchid3'],
"    \      },
"    \      'vim': {
"    \         'parentheses': ['start=/(/ end=/)/', 'start=/\[/ end=/\]/', 'start=/{/ end=/}/ fold', 'start=/(/ end=/)/ containedin=vimFuncBody', 'start=/\[/ end=/\]/ containedin=vimFuncBody', 'start=/{/ end=/}/ fold containedin=vimFuncBody'],
"    \      },
"    \      'html': {
"    \         'parentheses': ['start=/\v\<((area|base|br|col|embed|hr|img|input|keygen|link|menuitem|meta|param|source|track|wbr)[ >])@!\z([-_:a-zA-Z0-9]+)(\s+[-_:a-zA-Z0-9]+(\=("[^"]*"|'."'".'[^'."'".']*'."'".'|[^ '."'".'"><=`]*))?)*\>/ end=#</\z1># fold'],
"    \      },
"    \      'css': 0,
"    \   }
"    \}
" """""""""""""""" /Rainbow (foldering) """""""""""""""""""



"""""""""""""""""""""""""" fzf """""""""""""""""""""""""""
silent if has('unix') && g:dein_exists && dein#check_install('fzf') == 0
   " Set up keyboard shortbuts for fzf, the fuzzy finder
   " This one searches all the files in the current git repo:
   noremap <c-k> :GitFiles<CR>
   noremap <leader><Tab> :Buffers<CR>
   noremap gsiw :GGrepIW<cr>

   " Unmap center/<CR> from launching fzf which appears to be mapped by default.
   " unmap <CR>

   " This is the order of preference
   if executable('rg')
      let g:search_tool='rg'
   elseif executable('ag')
      let g:search_tool='ag'
   else
      let g:search_tool='grep'
   endif

   if g:search_tool ==? 'rg'
      noremap <leader>g :Rg<cr>
      command! -nargs=* -bang GGrepIW
         \ call fzf#vim#grep(
         \   'rg --column --line-number --no-heading --color=always --smart-case '.shellescape(expand('<cword>')).' '.getcwd(), 1,
         \   fzf#vim#with_preview(), <bang>0)
   else
      noremap <leader>g :Ag<cr>
      command! -nargs=* -bang GGrepIW
        \ call fzf#vim#grep(
        \    'ag --nogroup --column --color -s '.shellescape(expand('<cword>')).' '.getcwd(), 1,
        \    fzf#vim#with_preview(), <bang>0)
   endif

   noremap <leader>l :Lines<cr>
   noremap <leader>f :Files<cr>
   noremap <leader>w :Windows<cr>

   silent if has('unix') && g:dein_exists && dein#check_install('vim-fzf-repo') == 0
      noremap <leader>k :GRepoFiles<cr>
   endif
endif
""""""""""""""""""""""""" /fzf """""""""""""""""""""""""""

""""""""""""""""""""" Generate UUID """"""""""""""""""""""""
if has('unix')
   silent! py import uuid
   noremap <leader>u :s/REPLACE_UUID/\=pyeval('str(uuid.uuid4())')/g
   noremap <leader>ru :%s/REPLACE_UUID/\=pyeval('str(uuid.uuid4())')/g
endif
"""""""""""""""""""" /Generate UUID """"""""""""""""""""""""

filetype on
syntax on
map <S-Insert> <MiddleMouse>
map! <S-Insert> <MiddleMouse>
let fortran_free_source=1
let fortran_have_tabs=1
set number
set ignorecase
set noincsearch
set hlsearch
" if 0==is_win
"    set ff=unix,dos
" endif

" Easy save
noremap <leader>w :w<CR>
inoremap <C-S> <Esc>:w<CR>
" map alt/apple or something-S for khea

" Remove trailing space
nnoremap <leader>rt :silent! %s/\s\+$//e<CR>
let @r='\rt'
let @t=':try|silent! exe "norm! @r"|endtry|w|n'
autocmd FileType php,bp,c,cpp,h,hpp,aidl,javascript,python autocmd BufWritePre <buffer> :call setline(1,map(getline(1,"$"),'substitute(v:val,"\\s\\+$","","")'))

" Ignore whitespace on vimdiff
if &diff
   " diff mode
   set diffopt+=iwhite
endif

" Faster vertical expansion
nmap <C-v> :vertical resize +5<cr>
nmap <C-b> :above resize +5<cr>

" Swap splits to vertical
noremap <C-w>th <C-W>t<c-w>H
noremap <C-w>tv <C-W>t<c-w>K

" Remove search results
noremap H :noh<cr>

" Replace highlighted content with content of register 0
noremap <C-p> ciw<Esc>"0p

" Un-indent current line by one tab stop
imap <S-Tab> <C-o><<

" Stay in visual mode when indenting. You will never have to run gv after
" performing an indentation.
vnoremap < <gv
vnoremap > >gv

" Auto-correct spelling mistakes
" source: https://castel.dev/post/lecture-notes-1/
set spelllang=en_gb,en_us
inoremap <C-l> <c-g>u<Esc>[s1z=`]a<c-g>u

" Map // to search for highlighted text. Source
" http://vim.wikia.com/wiki/Search_for_visually_selected_text
" TODO learn how to get the selected text escaped
vnoremap // y/<C-R>"<CR>

" Use ESC to except insert mode in Nvim terminal
:tnoremap <Esc> <C-\><C-n>

" " Search of IP addresses
" nnoremap /ip /\<\(\d\{1,3\}\.\d\{1,3\}\.\d\{1,3\}\.\d\{1,3\}\\|localhost\)\><CR>

" Match <> brackets
set matchpairs+=<:>

" try to automatically fold xml
let xml_syntax_folding=1

" Without this, mouse wheel in vim/tmux scrolls tmux history, not vim's buffer
set mouse=a

"
" Abbreviations.  Check https://github.com/tpope/vim-abolish for how to make
" these case insensitive (if I need it)
ab flaot float
ab boid void
ab laster laser
ab jsut just
ab eticket etiket
ab breif brief
ab OPL2 OPAL2
ab unqiue unique
ab unique unique
ab AdditionaInputs AdditionalInputs
ab cosnt const
ab horizonal horizontal
ab appraoch approach
ab yeild yield
ab lsit list

" Append modeline after last line in buffer.
" Use substitute() instead of printf() to handle '%%s' modeline in LaTeX
" files.
function! AppendModeline()
  let l:modeline = printf(" vim: set ts=%d sw=%d tw=%d %set :",
        \ &tabstop, &shiftwidth, &textwidth, &expandtab ? '' : 'no')
  let l:modeline = substitute(&commentstring, "%s", l:modeline, "")
  call append(line("$"), l:modeline)
endfunction
nnoremap <silent> <leader>wl :call AppendModeline()<CR>

" Echo full file path
command! Ep :echo expand('%:p')
if executable('/opt/android-src/aos/out/soong/host/linux-x86/bin/bpfmt')
   command! Bp :!/opt/android-src/aos/out/soong/host/linux-x86/bin/bpfmt -w %
elseif executable('/opt/phoenix/phx-aosp-workspace/out/soong/host/linux-x86/bin/bpfmt')
   command! Bp :w | !/opt/phoenix/phx-aosp-workspace/out/soong/host/linux-x86/bin/bpfmt -w %
endif

" vim: ts=3 sts=3 sw=3 expandtab nowrap ff=unix :
