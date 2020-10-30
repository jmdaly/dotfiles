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
   au BufNewFile,BufRead *.dot               setlocal ft=sh

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

   " Ford
   au BufNewFile,BufRead *.fidl              setlocal ft=fidl
   au BufNewFile,BufRead */Config.in         setlocal ft=make
   au BufNewFile,BufRead */Config.in.host    setlocal ft=make

   au BufNewFile,BufRead Dockerfile*         setlocal ft=dockerfile
   au BufNewFile,BufRead */modulefiles/**    setlocal ft=tcl
   au BufNewFile,BufRead */.conan/profiles/* setlocal ft=sh
   au BufNewFile,BufRead *.te                setlocal ft=sh
   au BufNewFile,BufRead file_contexts       setlocal ft=sh
augroup end

augroup whitespace
   autocmd!
   autocmd FileType cs              setlocal ff=dos
   autocmd FileType yaml,json       setlocal ts=2 sw=2 sts=2 expandtab ai
   autocmd FileType tex             setlocal spell
   autocmd FileType xml             setlocal ts=2 sw=2 sts=2 expandtab ai
   autocmd FileType cmake           setlocal ts=2 sw=2 sts=2 expandtab ai
   autocmd FileType make            setlocal ts=8 sw=8 sts=8 noet ai
   autocmd FileType fidl            setlocal ts=2 sw=2 sts=2 expandtab ai
   autocmd FileType gitcommit       setlocal ts=2 sw=2 sts=2 expandtab spell | syntax off
   autocmd FileType groovy          setlocal ts=4 sw=4 sts=4 expandtab
   autocmd FileType cs,cpp,c,sh,ps1,kotlin setlocal ts=4 sw=4 sts=4 expandtab
   autocmd FileType bzl,javascript  setlocal ts=4 sw=4 sts=4 expandtab
augroup END

" Set the comment string for certain filetypes to
" double slashes (used for vim-commentary):
augroup FTOptions
    autocmd!
    autocmd FileType c,cpp,cs,java,bzl,javascript setlocal commentstring=//\ %s
    autocmd FileType cmake                        setlocal commentstring=#\ %s
augroup END

augroup SHORTCUTS
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

      " if has('unix') && 0==is_winbash && 0==is_win
      " If this doesn't work for c#, try
      "  https://github.com/neoclide/coc.nvim
      " if 0 && has('unix')
      if has('unix')
         " For some reason I'm set to the 'auto' branch of YCM.. Not sure why
            " \      'rev': 'auto'
         call dein#add('Valloric/YouCompleteMe',
            \ {
            \     'build': 'bash ./install.py --clang-completer --clang-tidy'
            \ },
         \ )

         " Not doing C# anymore..
         " call dein#add('OmniSharp/omnisharp-vim', {'on_ft': ['cs', 'aspx']})

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

         " ccls
         call dein#add('autozimu/LanguageClient-neovim',
             \ {
             \   'rev': 'next',
             \   'build': 'bash install.sh',
             \ }
         \ )
      endif

      call dein#add('udalov/kotlin-vim')

      if has('unix') && !exists('g:gui_oni')
         " Install fzf, the fuzzy searcher (also loads Ultisnips)
         call dein#add('junegunn/fzf', { 'build': './install --all', 'merged': 0 })
         call dein#add('junegunn/fzf.vim', {'depends': 'fzf' })
      endif

      " call dein#add('calincru/qml.vim', {'on_ft': ['qml']})
      " call dein#add('tikhomirov/vim-glsl', {'on_ft': ['glsl']})

      call dein#add('PProvost/vim-ps1')
      call dein#add('rubberduck203/aosp-vim')

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

silent if g:dein_exists && dein#check_install('vim-managecolor') == 0
   let g:colo_search_path = g:dotfiles . '/bundles/dein'
   let g:colo_cache_file  = g:dotfiles . '/colos.json'
   colo flatland
   " colo argonaut
endif


""""""""""""""""""""" Git-Gutter """"""""""""""""""""""""
nmap ]h <Plug>GitGutterNextHunk
nmap [h <Plug>GitGutterPrevHunk
" stage the hunk with <Leader>hs or
" revert it with <Leader>hr.
""""""""""""""""""""" /Git-Gutter """"""""""""""""""""""""

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
"""""""""""""""""""""" /Lightline """"""""""""""""""""""""

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

   " if 1 == g:buildroot
   "    echom "Adding extra options"
   let br_extra_options=
      \ "-target aarch64-unknown-nto-qnx7.0.0
      \ -fsyntax-only -mlittle-endian
      \ -isystem ".$QNX_HOST."/usr/lib/gcc/aarch64-unknown-nto-qnx7.0.0/5.4.0/include
      \ -isystem ".$QNX_HOST."/usr/aarch64-buildroot-nto-qnx/sysroot/usr/include/c++/v1
      \ -isystem ".$QNX_HOST."/usr/aarch64-buildroot-nto-qnx/sysroot/usr/include"
   let g:ale_cpp_clangtidy_extra_options='-- ' . br_extra_options

   " Set up mapping to move between errors
   nmap <silent> [w <Plug>(ale_previous_wrap)
   nmap <silent> ]w <Plug>(ale_next_wrap)

   " Run clang-format
   autocmd FileType c,cpp,h,hpp nnoremap <buffer><Leader>f :ALEFix<CR>
endif
""""""""""""""""""""""""""" /ALE """""""""""""""""""""""""


" For vim-cpp-enhanced-highlight, turn on highlighting of class scope:
let g:cpp_class_scope_highlight = 1


" Have vim reload a file if it has changed outside
" of vim:
if !has('nvim')
   set autoread
endif

""""""""""""""""""""""" YCM Config """"""""""""""""""""""""
silent if g:dein_exists && dein#check_install('YouCompleteMe') == 0
   " Let YouCompleteMe use tag files for completion as well:
   let g:ycm_collect_identifiers_from_tags_files = 1

   " Turn off prompting to load .ycm_extra_conf.py:
   let g:ycm_confirm_extra_conf = 0

   " Compile the file
   nnoremap <leader>y :YcmDiag<CR>

   " Ignore some files
   let g:ycm_filetype_blacklist = {
      \ 'tagbar'    : 1,
      \ 'qf'        : 1,
      \ 'notes'     : 1,
      \ 'markdown'  : 1,
      \ 'unite'     : 1,
      \ 'text'      : 1,
      \ 'vimwiki'   : 1,
      \ 'pandoc'    : 1,
      \ 'infolog'   : 1,
      \ 'vim'       : 1,
      \ 'gitcommit' : 1,
      \ 'gitrebase' : 1,
      \ 'cmake'     : 1,
      \ 'mail'      : 1,
      \ 'frag'      : 1,
      \ 'vert'      : 1,
      \ 'comp'      : 1,
      \ 'qml'       : 1,
      \ 'tex'       : 1,
      \ 'lcm'       : 1,
      \ 'bzl'       : 1
   \}

   let g:ycm_filetype_whitelist = {
      \ 'javascript': 1,
      \ 'python'    : 1,
      \ 'css'       : 1,
      \ 'cpp'       : 1,
      \ 'cs'        : 1,
      \ 'php'       : 1,
      \ 'fortran'   : 1,
      \ 'xml'       : 1,
      \ 'html'      : 1
   \}

   " Ignore large files (BONA db's for instance)
   let g:ycm_disable_for_files_larger_than_kb = 300

   " Shut off preview window on PHP files
   au BufNewFile,BufRead *.php let g:ycm_add_preview_to_completeopt=0

   if exists('g:python_host_prog')
      let g:interpreter_path = g:python_host_prog
   endif

   map <F9> :YcmCompleter FixIt<CR>
endif
"""""""""""""""""""""" /YCM Config """"""""""""""""""""""""

""""""""""""""""""" OmniSharp Config """"""""""""""""""""""
silent if g:dein_exists && dein#check_install('omnisharp-vim') == 0

   if 1==is_winbash
      " WSL config
      let g:OmniSharp_server_path = $WINHOME .'/omnisharp-roslyn/artifacts/publish/OmniSharp.Stdio.Driver/win7-x64/OmniSharp.exe'
      let g:OmniSharp_translate_cygwin_wsl = 1
   else
      " Linux config
      let g:OmniSharp_server_use_mono = 1
   endif

   " Use stdio in vim to be asynchronous
   let g:OmniSharp_server_stdio = 1

   " Use fzf.vim
   let g:OmniSharp_selector_ui = 'fzf'
   " Tell ALE to use OmniSharp for linting C# files, and no other linters.
   let g:ale_linters = { 'cs': ['OmniSharp'] }

   " Debug
   " let g:OmniSharp_loglevel = 'debug'
   " let g:OmniSharp_proc_debug = 1

   " Update semantic highlighting after all text changes
   let g:OmniSharp_highlight_types = 3
   " Update semantic highlighting on BufEnter and InsertLeave
   " let g:OmniSharp_highlight_types = 2

   " Copied from https://github.com/OmniSharp/omnisharp-vim
   augroup omnisharp_commands
       autocmd!

       " Show type information automatically when the cursor stops moving
       autocmd CursorHold *.cs call OmniSharp#TypeLookupWithoutDocumentation()

       " The following commands are contextual, based on the cursor position.
       autocmd FileType cs nnoremap <buffer> gd :OmniSharpGotoDefinition<CR>
       autocmd FileType cs nnoremap <buffer> <Leader>fi :OmniSharpFindImplementations<CR>
       autocmd FileType cs nnoremap <buffer> <Leader>rj :OmniSharpFindImplementations<CR>
       autocmd FileType cs nnoremap <buffer> <Leader>fs :OmniSharpFindSymbol<CR>
       autocmd FileType cs nnoremap <buffer> <Leader>fu :OmniSharpFindUsages<CR>

       " Finds members in the current buffer
       autocmd FileType cs nnoremap <buffer> <Leader>fm :OmniSharpFindMembers<CR>

       autocmd FileType cs nnoremap <buffer> <Leader>fx :OmniSharpFixUsings<CR>
       autocmd FileType cs nnoremap <buffer> <Leader>tt :OmniSharpTypeLookup<CR>
       autocmd FileType cs nnoremap <buffer> <Leader>dc :OmniSharpDocumentation<CR>
       autocmd FileType cs nnoremap <buffer> <C-\> :OmniSharpSignatureHelp<CR>
       autocmd FileType cs inoremap <buffer> <C-\> <C-o>:OmniSharpSignatureHelp<CR>

       " " Navigate up and down by method/property/field
       " autocmd FileType cs nnoremap <buffer> <C-k> :OmniSharpNavigateUp<CR>
       " autocmd FileType cs nnoremap <buffer> <C-j> :OmniSharpNavigateDown<CR>

       " Find all code errors/warnings for the current solution and populate the quickfix window
       autocmd FileType cs nnoremap <buffer> <Leader>cc :OmniSharpGlobalCodeCheck<CR>
   augroup END

   " Contextual code actions (uses fzf, CtrlP or unite.vim when available)
   nnoremap <Leader><Space> :OmniSharpGetCodeActions<CR>
   " Run code actions with text selected in visual mode to extract method
   xnoremap <Leader><Space> :call OmniSharp#GetCodeActions('visual')<CR>

   " Rename with dialog
   nnoremap <Leader>nm :OmniSharpRename<CR>
   nnoremap <F2> :OmniSharpRename<CR>
   " Rename without dialog - with cursor on the symbol to rename: `:Rename newname`
   command! -nargs=1 Rename :call OmniSharp#RenameTo("<args>")

   nnoremap <Leader>cf :OmniSharpCodeFormat<CR>

   " Start the omnisharp server for the current solution
   nnoremap <Leader>ss :OmniSharpStartServer<CR>
   nnoremap <Leader>sp :OmniSharpStopServer<CR>

   " Enable snippet completion
   " let g:OmniSharp_want_snippet=1

endif
""""""""""""""""""" /OmniSharp Config """""""""""""""""""""


""""""""""""""""" LanguageClient Config """""""""""""""""""
silent if has('unix') && g:dein_exists && dein#check_install('LanguageClient-neovim') == 0
   let g:LanguageClient_serverCommands = {
      \ 'cpp': [
         \ 'ccls',
         \ '--log-file=/tmp/cq.log',
         \ '-v=1'
      \ ]
   \ }
   let g:LanguageClient_loadSettings = 1
   let g:LanguageClient_settingsPath = g:dotfiles . '/ccls_settings.json'
   " Limits how often the LanguageClient talks to the
   " server, so it reduces CPU load and flashing.
   let g:LanguageClient_changeThrottle = 0.5
   let g:LanguageClient_diagnosticsEnable = 0
   nnoremap <leader>ty :call LanguageClient#textDocument_hover()<CR>
   nnoremap <leader>rf :call LanguageClient#textDocument_references()<CR>
   nnoremap <leader>rj :call LanguageClient#textDocument_definition()<CR>
   nnoremap <leader>rT :call LanguageClient#textDocument_definition({'gotoCmd': 'tabe'})<CR>
   nnoremap <leader>rS :call LanguageClient#textDocument_definition({'gotoCmd': 'split'})<CR>
   nnoremap <leader>rX :call LanguageClient#textDocument_definition({'gotoCmd': 'split'})<CR>
   nnoremap <leader>rV :call LanguageClient#textDocument_definition({'gotoCmd': 'vsplit'})<CR>
   nnoremap <leader>rw :call LanguageClient#textDocument_rename()<CR>
endif
""""""""""""""""" /LanguageClient Config """"""""""""""""""

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
   set rtp+=g:dotfiles
endif
""""""""""""""""""" /Ultisnips config """"""""""""""""""""""


"""""""""""""""""""" rooter config """"""""""""""""""""""
silent if g:dein_exists && dein#check_install('vim-rooter') == 0
   " Stop printing the cwd on write
   let rooter_silent_chdir=1
endif
""""""""""""""""""" /rooter config """"""""""""""""""""""


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
   noremap <c-j> :Files<CR>
   noremap gsiw :GGrepIW<cr>
   noremap <leader>s :Snippets<cr>
   noremap <leader>c :Colors<cr>

   " Unmap center/<CR> from launching fzf which appears to be mapped by default.
   " unmap <CR>

   let g:search_tool='rg'
   if g:search_tool ==? 'rg'
      noremap <leader>g :Rg<cr>
      command! -nargs=* -bang GGrepIW
         \ call fzf#vim#grep(
         \   'rg --column --line-number --no-heading --color=always --smart-case '.shellescape(expand('<cword>')), 1,
         \   fzf#vim#with_preview(), <bang>0)
   else
      noremap <leader>g :Ag<cr>
      command! -nargs=* -bang GGrepIW
        \ call fzf#vim#grep(
        \    'ag --nogroup --column --color -s '.shellescape(expand('<cword>')), 1,
        \    fzf#vim#with_preview(), <bang>0)
   endif

   noremap <leader>l :Lines<cr>
   noremap <leader>w :Windows<cr>

   silent if has('unix') && g:dein_exists && dein#check_install('vim-fzf-repo') == 0
      noremap <leader>k :GRepoFiles<cr>
   endif
endif
""""""""""""""""""""""""" /fzf """""""""""""""""""""""""""


"""""""""""""""""""""" prosession  """"""""""""""""""""""""
" Options: https://github.com/dhruvasagar/vim-prosession/blob/master/doc/prosession.txt
"""""""""""""""""""""" /prosession """"""""""""""""""""""""

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
let trim_whitelist = ['php', 'js', 'cpp', 'h', 'vim', 'css', 'bzl']
autocmd BufWritePre * if index(trim_whitelist, &ft) >= 0 | :%s/\s\+$//e

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

" Map // to search for highlighted text. Source http://vim.wikia.com/wiki/Search_for_visually_selected_text
vnoremap // y/<C-R>"<CR>

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
  let l:modeline = printf("vim: set ts=%d sw=%d tw=%d %set :",
        \ &tabstop, &shiftwidth, &textwidth, &expandtab ? '' : 'no')
  let l:modeline = substitute(&commentstring, "%s", l:modeline, "")
  call append(line("$"), l:modeline)
endfunction
nnoremap <silent> <leader>wl :call AppendModeline()<CR>

" Echo full file path
command! Ep :echo expand('%:p')

" vim: ts=3 sts=3 sw=3 expandtab nowrap ff=unix :
