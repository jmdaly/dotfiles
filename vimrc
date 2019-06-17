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
		let $WINHOME     = 'c:/users/' . $USERNAME
		let g:dotfiles   = $WINHOME . '/dotfiles'
		let g:env_folder = $WINHOME . '/.virtualenvs/default'
	endif
endif

if has('nvim')
	if has('win32')
		let g:python_host_prog  = expand(g:env_folder . '/Scripts/python.exe')
		let g:python3_host_prog = g:python_host_prog
	else
		let g:python_host_prog  = expand(g:env_folder . '/bin/python')
		let g:python3_host_prog = g:python_host_prog . '3'
	endif

	if empty(glob(g:python_host_prog))
		echom 'Could not find g:python_host_prog = '. g:python_host_prog
	endif
	if empty(glob(g:python3_host_prog))
		echom 'Could not find g:python3_host_prog = '. g:python3_host_prog
	endif
endif


" Configure some unconventional filetypes
augroup filetypes
	au BufNewFile,BufRead *.html.base      set filetype=html
	au BufNewFile,BufRead *.ftn90          set filetype=fortran
	au BufNewFile,BufRead *.cdk*           set filetype=fortran
	au BufNewFile,BufRead *.nml            set filetype=fortran
	au BufNewFile,BufRead *.module         set filetype=php
	au BufNewFile,BufRead *.dot            set filetype=sh
	au BufNewFile,BufRead *.gs             set filetype=javascript
	au BufNewFile,BufRead *.spi            set filetype=tcl
	au BufNewFile,BufRead .exper_cour      set filetype=sh
	au BufNewFile,BufRead *.lcm            set filetype=c
	au BufNewFile,BufRead Common_Compiler* set filetype=sh
	au BufNewFile,BufRead */Wt/W*          set filetype=cpp
	au BufNewFile,BufRead *recettes        set filetype=make
	au BufNewFile,BufRead *cibles          set filetype=make
	au BufNewFile,BufRead *.qml            set filetype=qml
	au BufNewFile,BufRead *.qrc            set filetype=xml
	au BufNewFile,BufRead *.pro            set filetype=make
	au BufNewFile,BufRead *.vert           set filetype=glsl
	au BufNewFile,BufRead *.geo            set filetype=glsl
	au BufNewFile,BufRead *.frag           set filetype=glsl
	au BufNewFile,BufRead BuildScripts/profiles/* set filetype=sh
	au BufNewFile,BufRead /mnt/c/*         set ffs=dos
augroup end

set nocompatible  " Dein also wants this

" Enable true colour support:
if !exists('g:gui_oni') && has('termguicolors')
  set termguicolors
endif


" if
" 	" Colour coding nests
" 	Plug 'luochen1990/rainbow'
" 	let g:rainbow_active = 1 "0 if you want to enable it later via :RainbowToggle
" endif

" Javascript plugins to try
" if
	" Plug 'pangloss/vim-javascript'
   "
	" " General conceal settings. Will keep things concealed
	" " even when your cursor is on top of them.
	" Plug 'Wolfy87/vim-syntax-expand'
	" set conceallevel=1
	" set concealcursor=nvic
   "
	" " vim-javascript conceal settings.
	" let g:javascript_conceal_function = "λ"
	" let g:javascript_conceal_this = "@"
	" let g:javascript_conceal_return = "<"
	" let g:javascript_conceal_prototype = "#"
" endif

" Plug 'othree/javascript-libraries-syntax.vim'
" Plug 'scrooloose/syntastic' " <-- using jshint for syntax


if (v:version >= 800 || has('nvim'))
	let &runtimepath.=',' . g:dotfiles . '/bundles/dein/repos/github.com/Shougo/dein.vim'

	" Required:
	if dein#load_state(string(g:dotfiles . '/bundles/dein'))
		call dein#begin(g:dotfiles . '/bundles/dein')

		" Let dein manage dein
		call dein#add(g:dotfiles . '/bundles/dein/repos/github.com/Shougo/dein.vim')

		" Lazy-load on C++
		call dein#add('octol/vim-cpp-enhanced-highlight', {'on_ft': ['c', 'cpp', 'h', 'hpp']})
		" call dein#add('vim-scripts/DoxygenToolkit.vim', {'on_ft': ['c', 'cpp', 'h', 'hpp']})

		" Lazy-load on PHP
		call dein#add('shawncplus/phpcomplete.vim', {'on_ft': ['php']})

		" Lazy-load on python
		call dein#add('Hdima/python-syntax', {'on_ft': ['py']})

		" fugitive - a Git wrapper for vim. Also allows current
		call dein#add('tpope/vim-fugitive')
		set diffopt+=vertical

		if has('unix') && 0==is_winbash && 0==is_win
			call dein#add('Valloric/YouCompleteMe',
				\ {
				\ 	'rev': 'auto',
				\	'build': 'bash ./install.py --clang-completer --clang-tidy'
				\ }
			\ )

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

		" Plug to assist with commenting out blocks of text:
		call dein#add('tomtom/tcomment_vim')

		" Tabular, align equals
		call dein#add('godlygeek/tabular')

		" Show markers
		call dein#add('kshenoy/vim-signature')

		" Grep through repo
		call dein#add('mhinz/vim-grepper')

		" call dein#add('elzr/vim-json')

		" Status bar
		call dein#add('powerline/powerline')

		if has('unix')
			call dein#add('rhysd/vim-clang-format')
		endif

		" A plugin for asynchronous linting while you type
		call dein#add('w0rp/ale')

		call dein#add('airblade/vim-gitgutter')

		" Display trailing whitespace
		call dein#add('ntpeters/vim-better-whitespace')

		" Asynchronous linting
		call dein#add('benekastah/neomake') " Asynchronous linting

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

		if !exists('g:gui_oni') && has('nvim') && 0==is_winbash
			call dein#add('vimlab/split-term.vim')

			" ccls
			call dein#add('autozimu/LanguageClient-neovim',
				 \ {
				 \	'rev': 'next',
				 \	'build': 'bash install.sh',
				 \ }
			\ )
		endif

		if has('unix') && !exists('g:gui_oni')
			" Install fzf, the fuzzy searcher (also loads Ultisnips)
			call dein#add('junegunn/fzf', {'build': './install --all' } )
			call dein#add('junegunn/fzf.vim', {'depends': 'junegunn/fzf' })
		endif

		" call dein#add('calincru/qml.vim', {'on_ft': ['qml']})
		" call dein#add('tikhomirov/vim-glsl', {'on_ft': ['glsl']})

		call dein#add('PProvost/vim-ps1')

		"
		" Colourschemes
		call dein#add('altercation/vim-colors-solarized')
		call dein#add('kristijanhusak/vim-hybrid-material')
		call dein#add('atelierbram/vim-colors_duotones')
		call dein#add('atelierbram/vim-colors_atelier-schemes')


		" Other..
		call dein#add('joshdick/onedark.vim')
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

silent if dein#check_install('vim-managecolor') == 0
	let g:colo_search_path = g:dotfiles . '/bundles/dein'
	let g:colo_cache_file  = g:dotfiles . '/colos.json'
	colo cobalt2
endif


""""""""""""""""""""" Git-Gutter """"""""""""""""""""""""
nmap ]h <Plug>GitGutterNextHunk
nmap [h <Plug>GitGutterPrevHunk
" stage the hunk with <Leader>hs or
" revert it with <Leader>hr.
""""""""""""""""""""" /Git-Gutter """"""""""""""""""""""""

""""""""""""""""""" vim-clang-format """""""""""""""""""""
" Detect clang-format file
let g:clang_format#detect_style_file = 1

" Key mappings for clang-format, to format source code:
if has('unix')
	autocmd FileType c,cpp,h,hpp nnoremap <buffer><Leader>fo :pyf /usr/share/clang/clang-format.py<CR>
	autocmd FileType c,cpp,h,hpp nnoremap <buffer><Leader>f :<C-u>ClangFormat<CR>
	autocmd FileType c,cpp,h,hpp vnoremap <buffer><Leader>f :ClangFormat<CR>

	" map <leader>f :pyf /usr/share/clang/clang-format.py<CR>

	nmap <Leader>C :ClangFormatAutoToggle<CR>
endif

" ALE configuration
" TODO I think the vimrc in https://github.com/TalAmuyal/MyConfigs has a
" better formatting package
if has('unix')
	let g:ale_linters = {
	\   'cpp': ['clangtidy'],
	\}
	let g:ale_cpp_clangtidy_checks = ['clang-analyzer-*', 'modernize-*', 'performance-*', 'readability-*', 'google-readability-casting']
	let g:ale_cpp_clangtidy_executable = '/usr/bin/clang-tidy'
	" Set up mapping to move between errors
	nmap <silent> [w <Plug>(ale_previous_wrap)
	nmap <silent> ]w <Plug>(ale_next_wrap)
endif

""""""""""""""""""" /vim-clang-format """"""""""""""""""""

" For vim-cpp-enhanced-highlight, turn on highlighting of class scope:
let g:cpp_class_scope_highlight = 1

" Tell vim to set the current directory to the directory
" of the file being opened:
if domain !=? 'siteground'
	set autochdir
endif

" Have vim reload a file if it has changed outside
" of vim:
if !has('nvim')
	set autoread
endif

if has('unix')
	" Tell vim to look for a tags file in the current
	" directory, and all the way up until it finds one:
	set tags=./tags;/
endif

""""""""""""""""""""""" YCM Config """"""""""""""""""""""""
silent if dein#check_install('YouCompleteMe') == 0
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
		\ 'lcm'       : 1
	\}

	let g:ycm_filetype_whitelist = {
		\ 'javascript': 1,
		\ 'python'    : 1,
		\ 'css'       : 1,
		\ 'cpp'       : 1,
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
		let g:interpreter_path = '/usr/bin/python'
	endif

	map <F9> :YcmCompleter FixIt<CR>
endif
"""""""""""""""""""""" /YCM Config """"""""""""""""""""""""

""""""""""""""""" LanguageClient Config """""""""""""""""""
if !exists('g:gui_oni')
	let g:LanguageClient_serverCommands = {
		\ 'cpp': ['ccls', '--log-file=/tmp/cq.log']
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
	nnoremap <leader>rV :call LanguageClient#textDocument_definition({'gotoCmd': 'vsplit'})<CR>
	nnoremap <leader>rw :call LanguageClient#textDocument_rename()<CR>
endif
""""""""""""""""" /LanguageClient Config """"""""""""""""""

"""""""""""""""""""" Ultisnips config """"""""""""""""""""""
" Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
silent if dein#check_install('ultisnips') == 0
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


""""""""""""""""""""""" Grepper """"""""""""""""""""""""""
" Grepper key bindings:
" Define an operator that takes any motion and
" uses it to populate the search prompt:
nmap gs <plug>(GrepperOperator)
xmap gs <plug>(GrepperOperator)

" Have git grep perform searches throughout the whole repo
" regardless of the directory we are currently in:
let g:grepper     = {
	\ 'open':    1,
	\ 'jump':    0,
	\ 'switch':  1,
	\ 'git':     { 'grepprg': 'git grep -nI $* -- `git rev-parse --show-toplevel`'},
   \ }

""""""""""""""""""""""" /Grepper """""""""""""""""""""""""


" """""""""""""""" Rainbow (foldering) """""""""""""""""""
" 	let g:rainbow_conf = {
" 	\   'guifgs': ['royalblue3', 'darkorange3', 'seagreen3', 'firebrick'],
" 	\   'ctermfgs': ['lightblue', 'lightyellow', 'lightcyan', 'lightmagenta'],
" 	\   'operators': '_,_',
" 	\   'parentheses': ['start=/(/ end=/)/ fold', 'start=/\[/ end=/\]/ fold', 'start=/{/ end=/}/ fold'],
" 	\   'separately': {
" 	\	   '*': {},
" 	\	   'tex': {
" 	\		   'parentheses': ['start=/(/ end=/)/', 'start=/\[/ end=/\]/'],
" 	\	   },
" 	\	   'cpp': {
" 	\		   'guifgs': ['royalblue3', 'darkorange3', 'seagreen3', 'firebrick', 'darkorchid3'],
" 	\	   },
" 	\	   'vim': {
" 	\		   'parentheses': ['start=/(/ end=/)/', 'start=/\[/ end=/\]/', 'start=/{/ end=/}/ fold', 'start=/(/ end=/)/ containedin=vimFuncBody', 'start=/\[/ end=/\]/ containedin=vimFuncBody', 'start=/{/ end=/}/ fold containedin=vimFuncBody'],
" 	\	   },
" 	\	   'html': {
" 	\		   'parentheses': ['start=/\v\<((area|base|br|col|embed|hr|img|input|keygen|link|menuitem|meta|param|source|track|wbr)[ >])@!\z([-_:a-zA-Z0-9]+)(\s+[-_:a-zA-Z0-9]+(\=("[^"]*"|'."'".'[^'."'".']*'."'".'|[^ '."'".'"><=`]*))?)*\>/ end=#</\z1># fold'],
" 	\	   },
" 	\	   'css': 0,
" 	\   }
" 	\}
" """""""""""""""" /Rainbow (foldering) """""""""""""""""""



"""""""""""""""""""""""""" fzf """""""""""""""""""""""""""
if has('unix')
	" Set up keyboard shortbuts for fzf, the fuzzy finder
	" This one searches all the files in the current git repo:
	noremap <c-k> :GitFiles<CR>
	noremap <leader><Tab> :Buffers<CR>

	" Unmap center/<CR> from launching fzf which appears to be mapped by default.
	" unmap <CR>
endif
""""""""""""""""""""""""" /fzf """""""""""""""""""""""""""


"""""""""""""""""""""" prosession  """"""""""""""""""""""""
" Options: https://github.com/dhruvasagar/vim-prosession/blob/master/doc/prosession.txt
"""""""""""""""""""""" /prosession """"""""""""""""""""""""

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
if 0==is_win
	set ffs=unix,dos
endif

" Easy save
noremap <leader>w :w<CR>
inoremap <C-S> <Esc>:w<CR>
" map alt/apple or something-S for khea

" Remove trailing space
nnoremap <leader>rt :%s/\s\s*$//<CR>
let trim_whitelist = ['php', 'js', 'cpp', 'h', 'vim', 'css']
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
setlocal spell
set spelllang=en_gb,en_us
inoremap <C-l> <c-g>u<Esc>[s1z=`]a<c-g>u

" ST term fucks up the delete key, seeing it as <F1>, so fixing it in vim for
" now (might fix it better elsewhere)
" map <F1> x
" imap <F1> <DEL>

" Map // to search for highlighted text. Source http://vim.wikia.com/wiki/Search_for_visually_selected_text
vnoremap // y/<C-R>"<CR>

" Search of IP addresses
nnoremap /ip /\<\(\d\{1,3\}\.\d\{1,3\}\.\d\{1,3\}\.\d\{1,3\}\\|localhost\)\><CR>

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

" vim: ts=3 sts=3 sw=3 noet nowrap ffs=unix :
