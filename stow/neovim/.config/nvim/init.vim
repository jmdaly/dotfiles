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

if $TRUE_HOST !=? ''
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

" TODO Remove winbash, conflating the dotfiles just makes things complicated
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
   au BufNewFile,BufRead *.snippets          setlocal ft=snippet

   " EnvCan filetypes
   au BufNewFile,BufRead *.spi               setlocal ft=tcl
   au BufNewFile,BufRead *.dot               setlocal ft=zsh

   " NTC only-rules (so far)
   au BufNewFile,BufRead *.vert,*.geo,*.frag setlocal ft=glsl

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
   au BufNewFile,BufRead */aosp/*.rc          setlocal ft=sh
   au BufNewFile,BufRead *.envrc             setlocal ft=sh
   au BufNewFile,BufRead .jdbrc              setlocal ft=jdb
   au BufNewFile,BufRead .clangd             setlocal ft=yaml
   au BufNewFile,BufRead *.tmpl              setlocal ft=tmpl
   au BufNewFile,BufRead *.fsb               setlocal ft=fsb syntax=python
   au BufNewFile,BufRead *.dot               setlocal ft=zsh
   au BufNewFile,BufRead *.i3                setlocal ft=i3
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
   autocmd FileType cs,cpp,c,kotlin,java setlocal ts=4 sw=4 sts=4 expandtab
   autocmd FileType sh,ps1,dot      setlocal ts=2 sw=2 sts=2 expandtab
   autocmd FileType bzl,javascript  setlocal ts=4 sw=4 sts=4 expandtab
   autocmd FileType go              setlocal ts=2 sw=2 sts=2 expandtab
   autocmd FileType fsb             setlocal ts=2 sw=2 sts=2 noexpandtab
augroup END

" Set the comment string for certain filetypes to
" double slashes (used for vim-commentary):
augroup FTOptions
    autocmd!
    autocmd FileType c,cpp,cs,java,bzl,javascript,php setlocal commentstring=//\ %s
    autocmd FileType sh,jdb,cmake                     setlocal commentstring=#\ %s
    autocmd FileType tmpl                             setlocal commentstring=##\ %s
    autocmd FileType fsb                              setlocal commentstring=#\ %s
    autocmd FileType i3                               setlocal commentstring=#\ %s
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

if has('nvim-0.5')
   lua require('utils')
   lua require('plugins')
   lua require('completions')
endif


" Colour schemes
" colo hydrangea
" colo flatland
" colo argonaut
" colo ayu
" colo argonaut
colo doorhinge


""""""""""""""""""""""" Lightline """"""""""""""""""""""""
function! LightlineFilename()
   return &filetype ==# 'vimfiler' ? vimfiler#get_status_string() :
      \ &filetype ==# 'unite' ? unite#get_status_string() :
      \ &filetype ==# 'vimshell' ? vimshell#get_status_string() :
      \ expand('%:t') !=# '' ? @% : '[No Name]'
endfunction

function! LightlineReadonly()
   return &readonly ? '' : ''
endfunction

"""""""""""""""""""""" /Lightline """"""""""""""""""""""""


" For vim-cpp-enhanced-highlight, turn on highlighting of class scope:
let g:cpp_class_scope_highlight = 1

" Have vim reload a file if it has changed outside
" of vim:
if !has('nvim')
   set autoread
endif


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


""""""""""""""""""""" Generate UUID """"""""""""""""""""""""
if has('unix')
   silent! py import uuid
   noremap <leader>u :s/REPLACE_UUID/\=pyeval('str(uuid.uuid4())')/g
   noremap <leader>ru :%s/REPLACE_UUID/\=pyeval('str(uuid.uuid4())')/g
endif
"""""""""""""""""""" /Generate UUID """"""""""""""""""""""""

" Make W the same as w
" https://stackoverflow.com/a/3878710/1861346
command Q q
command W w
command Wqa wqa
" command Tabe tabe


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
inoremap <C-S> <Esc>:w<CR>
" map alt/apple or something-S for khea

" Remove trailing space
nnoremap <leader>rt :silent! %s/\s\+$//e<CR>
let @r='\rt'
let @t=':try|silent! exe "norm! @r"|endtry|w|n'
" autocmd FileType php,bp,c,cpp,h,hpp,aidl,javascript,python autocmd BufWritePre <buffer> :call setline(1,map(getline(1,"$"),'substitute(v:val,"\\s\\+$","","")'))

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

" Run bpfmt, really gotta handle the path better
if executable('/opt/phoenix/aosp/out/soong/host/linux-x86/bin/bpfmt')
   command! Bp :w | !/opt/phoenix/aosp/out/soong/host/linux-x86/bin/bpfmt -w %
endif

augroup FILE_FORMATTING
   " Formatters that aren't done _via_ the LSP
   autocmd FileType bp nnoremap <buffer><Leader>fu :Bp<CR>
   autocmd FileType python nnoremap <buffer><Leader>fu :Black<CR>
augroup END

" vim: ts=3 sts=3 sw=3 expandtab nowrap ff=unix :
