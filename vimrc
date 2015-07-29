
" Needed for Vundles
set shell=/bin/bash

" Used for host detection
let hostname = substitute(system('hostname'), '\n', '', '')

if hostname ==? 'pof' || hostname ==? 'tinder'
	let domain='neptec'
elseif hostname ==? 'dena' || hostname ==? 'sahand' || hostname ==? 'pontus' || hostname ==? 'pontus.cee.carleton.ca'
	let domain='school'
elseif $TRUE_HOST !=? ''
	let domain='school'
else
	let domain='home'
endif
"echo 'Using domain ' . domain

let is_win=0
let is_mac=0
let is_nix=1
if has('win32')||has('win32unix')
	let is_win=1
elseif has('mac')
	let is_mac=1
else
	let is_nix=1
endif


" Configure some unconventional filetypes
au BufNewFile,BufRead *.html.base set filetype=html
au BufNewFile,BufRead *.ftn90     set filetype=fortran
au BufNewFile,BufRead *.module    set filetype=php
au BufNewFile,BufRead *.gs        set filetype=javascript

"
" Vundle.  use :PluginInstall to install all these plugins
"

" set the runtime path to include Vundle and initialize
set nocompatible				  " be iMproved, required
filetype off						" required
set rtp+=~/dotfiles/Vundle.vim
call vundle#begin('~/dotfiles/bundles') " This always fails the second time around

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'

" Sourrounds paranthesis and stuff https://github.com/tpope/vim-surround
"Plugin 'tpope/vim-surround'

" Navigate around numbers easier.. https://github.com/Lokaltog/vim-easymotion
" Plugin 'Lokaltog/vim-easymotion'

" Solarized colour scheme
Plugin 'altercation/vim-colors-solarized.git'

" Atelier color scheme
Plugin 'atelierbram/vim-colors_atelier-schemes'
" base16-atelierforest base16-atelierplateau base16-atelierheath base16-ateliercave base16-ateliersulphurpool base16-atelierlakeside base16-ateliersavanna base16-atelierseaside base16-atelierdune base16-atelierestuary

" Full of colour schemes:
Plugin 'flazz/vim-colorschemes'
" Tomorrow Tomorrow-Night Tomorrow-Night-Eighties Tomorrow-Night-Bright Tomorrow-Night-Blue SlateDark PapayaWhip MountainDew Monokai Monokai-chris DevC++ c colorscheme_template colorful colorful256 colorer coldgreen coffee codeschool CodeFactoryv3 codeburn codeblocks_dark cobalt cobaltish clue cloudy clearance cleanroom cleanphp clarity ciscoacl chrysoprase chocolate ChocolatePapaya ChocolateLiquor chlordane chela_light Chasing_Logic charon charged-256 chance-of-storm cascadia carvedwood carvedwoodcool carrot caramel candy candyman candycode campfire camo calmar256-light cake16 C64 bw bvemu buttercream busybee busierbee burnttoast256 bubblegum brown brookstream breeze borland bog bocau bmichaelsen blugrine bluez blue blueshift blueprint bluegreen bluedrake bluechia blink blazer BlackSea blacklight blackdust blackboard blackbeauty black_angus biogoo billw bensday beauty256 beachcomber bclear bayQua baycomb basic base16-atelierdune badwolf babymate256 autumn autumnleaf automation atom asu1dark astronaut asmanian_blood ashen aqua apprentice ansi_blows anotherdark aiseered af advantage adrian adobe adaryn adam abra 3dglasses 256-jungle 256-grayvim 0x7A69_dark heliotrope habiLight h80 guepardo guardian gruvbox grishin greyblue grey2 greenvision greens grb256 graywh gravity grape gothic gotham gotham256 gor google golden golded gobo github getfresh getafe gentooish gemcolors gardener fu fruity fruit fruidle frood freya forneus fokus fog fnaqevan flatui flattr flatland flatlandia flatcolor fine_blue felipec far evening_2 enzyme emacs elrodeo elisex elise elda.vim* ekvoli ekinivim ego edo_sea editplus ecostation eclm_wombat eclipse earth earthburn earendel dusk dull dual doriath doorhinge donbass django distinguished disciple developer deveiate devbox-dark-256 detailed desert desertEx desertedocean desertedoceanburnt desert256 desert256v2 derefined denim delphi delek dawn darth darkZ darkzen darktango darkspectrum darkslategray dark-ruby darkroom darkrobot darkocean darker-robin darkerdesert darkeclipse darkdot darkburn darkbone darkBlue darkblue2 darkblack dante d8g_04 d8g_03 d8g_02 d8g_01 custom cthulhian corporation corn cool contrasty colorzone navajo-night nature native mustang muon mud mrpink mrkn256 motus moss moria mopkai mophiaSmoke mophiaDark montz monokain molokai mod_tcsoft mizore mint miko midnight midnight2 metacosm mellow mdark mayansmoke matrix martin_krischik mars maroloccio marklar manxome manuscript mango made_of_code mac_classic luna luinnar lucius louver lodestone lizard lizard256 literal_tango liquidcarbon lingodirector lilypink lilydjwg_green lilydjwg_dark lilac lightcolors leya lettuce less leo leglight2 legiblelight lazarus last256 landscape kyle kruby kolor kkruby kiss kib_plastic kib_darktango khaki kellys kate kalt kaltex kalisi jiks jhlight jhdark jellyx jellybeans jelleybeans jammy ironman ir_black inkpot ingretu industry industrial impact impactG iceberg icansee ibmedit iangenzo hybrid hybrid-light hornet holokai herokudoc herokudoc-gvim herald hemisu softblue softbluev2 smyck smp skittles_dark skittles_berry simplewhite simple_b simpleandfriendly simple256 silent sift sienna shobogenzo shadesofamber sf sexy-railscasts settlemyer seoul seoul256 seoul256-light selenitic sea seashell sean scite scala saturn satori sand rtl rootwater robinhood revolutions reloaded reliable relaxedgreen refactor redstring redblack rdark rdark-terminal rcg_term rcg_gui rastafari random rainbow_neon rainbow_fruit rainbow_fine_blue railscasts radicalgoodspeed quagmire python pyte pw putty psql pspad proton professional prmths print_bw potts pleasant playroom pink pic phpx phphaxor phd pf_earth perfect peppers pencil peaksea paintbox pacific otaku osx_like orange olive oceanlight oceandeep oceanblack oceanblack256 obsidian obsidian2 nuvola nour norwaytoday northsky northland no_quarter nightwish nightVision night_vision night nightsky nightshimmer nightflight nightflight2 nicotine newsprint newspaper nevfn neverness neverland neverland-darker neverland2 neverland2-darker neutron nerv-ous neon nefertiti nedit nedit2 nazca navajo zmrok zephyr zen zenesque zenburn zazen yeller yaml xterm16 xoria256 xmaslights xian xemacs wuye wood wombat wombat256 wombat256mod wombat256i winter wintersday win9xblueback widower whitedust whitebox watermark warm_grey wargrey vylight vydark void vj vividchalk visualstudio vilight vibrantink vexorian vc vcbc vanzan_color up underwater underwater-mod understated umber-green ubloh two2tango twitchy twilight twilight256 tutticolori turbo trogdor trivial256 transparent torte toothpik tony_light tomatosoup tolerable tir_black tidy tibet thor thestars thegoodluck textmate16 tetragrammaton tesla telstar tcsoft tchaba tchaba2 taqua tangoX tango tangoshady tango-morning tango-desert tango2 tabula synic symfony swamplight surveyor summerfruit summerfruit256 strawimodo strange stingray stackoverflow spring spiderhawk spectro southwest-fog southernlights soso sorcerer sonoma sonofobsidian sol sol-term solarized softlight

if is_win==0 && domain !=? 'school'
	" YouCompleteMe
	Plugin 'Valloric/YouCompleteMe'

	" YCMGenerator - generates configs for YouCompleteMe
	Plugin 'rdnetto/YCM-Generator'
endif

" PHP Complete
Plugin 'shawncplus/phpcomplete.vim'

" NERD Tree - file explorer for vim
Plugin 'scrooloose/nerdtree'

" Ctrl-P - fuzzy file finder
Plugin 'kien/ctrlp.vim'

" Better C++ Syntax Highlighting:
Plugin 'octol/vim-cpp-enhanced-highlight'

if is_win==0 && domain !=? 'school'
	" Track the ultisnips engine.
	Plugin 'SirVer/ultisnips'

	" Snippets are separated from the engine. Add this if you want them:
	Plugin 'honza/vim-snippets'
endif

if is_win==0 && (domain ==? 'neptec' || domain ==? 'home')
	" tagbar - allows browsing tags of the current source file
	" from ctags. Good for seeing functions, variables, etc.
	Plugin 'majutsushi/tagbar'
endif

if is_win==0 && (domain ==? 'neptec' || domain ==? 'home')
	" Key mappings for clang-format, to format source code:
	map <leader>f :pyf /usr/share/vim/addons/syntax/clang-format-3.6.py<CR>
endif

" vim-sleuth - heuristically determines spacing in terms
" of tabs, spaces, etc. based on what's in use in the
" current file and the file around it:
" Plugin 'tpope/vim-sleuth'

" fugitive - a Git wrapper for vim. Also allows current
" git branch to be shown by vim-airline:
Plugin 'tpope/vim-fugitive'
set diffopt+=vertical

" gitgutter - Shows [git] status of each line in a file
" Toggle with :GitGutterToggle
Plugin 'airblade/vim-gitgutter'

" Plugin to assist with commenting out blocks of text:
Plugin 'tomtom/tcomment_vim'

" vim-airline: 'Lean & mean status/tabline for vim that's light as air.'
Plugin 'bling/vim-airline'

" Switch between header and source files:
" TODO Make filetype specific: http://stackoverflow.com/questions/6133341/can-you-have-file-type-specific-key-bindings-in-vim
" Plugin 'derekwyatt/vim-fswitch'

" Plugin to help manage vim buffers:
" Plugin 'jeetsukumaran/vim-buffergator'

" Plugin to highlight the variable under the cursor:
Plugin 'OrelSokolov/HiCursorWords'

" Most Recently Used: http://www.vim.org/scripts/script.php?script_id=521
Plugin 'yegappan/mru'

if domain !=? 'school'
	" A plugin to use rtags in vim. (rtags allows for code following,
	" some refactoring, etc.)
	" Ensure to run the following in the build directory that uses rtags
	"    cmake . -DCMAKE_EXPORT_COMPILE_COMMANDS=1
	"    rc -J .
	" And have the rdm service running somewhere in the background.
	Plugin 'lyuts/vim-rtags'
endif

" Database client
Plugin 'vim-scripts/dbext.vim'

" Colour coding nests
Plugin 'luochen1990/rainbow'
let g:rainbow_active = 1 "0 if you want to enable it later via :RainbowToggle

" Tabular, align equals
Plugin 'godlygeek/tabular'

" Show markers
Plugin 'kshenoy/vim-signature'

" Suppose to make closing splits better (less window resizing)
Plugin 'moll/vim-bbye.git'

" Zoom into splits with <c-w>o
Plugin 'vim-scripts/ZoomWin'

" XML helper
"Plugin 'othree/xml.vim'

" Work with editorconfig files
"Plugin 'editorconfig-vim'

" Javascript plugins to try
" Plugin 'pangloss/vim-javascript'
" Plugin 'othree/javascript-libraries-syntax.vim'
" Plugin 'scrooloose/syntastic' " <-- using jshint for syntax

"if domain !=? 'school'
"	" Concurrent Editing
"	Plugin 'floobits/floobits-neovim'
"endif

" All of your Plugins must be added before the following line
call vundle#end()				" required
filetype plugin indent on	 " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList		 - lists configured plugins
" :PluginInstall	 - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean		- confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line



" Random Colorscheme
" TODO Add 'go to last colorschem'
" TODO Add 'mark as terrible colorscheme'
" TODO Add 'mark as good colorscheme'
function! s:RandColorScheme()
	let s:scheme=system('/usr/bin/env php ~/dotfiles/grabRandomColorscheme.php')
	execute ':colorscheme '.s:scheme
	echom 'Loading colorscheme ' s:scheme
endfunction
:map <Leader>rcs :call <SID>RandColorScheme()<CR>

" Grab a random whitelisted colour scheme
function! s:RandWhiteListColorScheme()
	let s:scheme=system('/usr/bin/env php ~/dotfiles/grabRandomColorscheme.php -w')
	execute ':colorscheme '.s:scheme
	echom 'Loading whitelist colorscheme ' s:scheme
endfunction
:map <Leader>wcs :call <SID>RandWhiteListColorScheme()<CR>

" Execute PHP lines http://stackoverflow.com/a/5622258/1861346
":autocmd FileType php noremap <C-M> :w!<CR>:!/usr/bin/php %<CR>

" Colour scheme
if has('gui_running')
	set mousemodel=popup

	" TODO Write a command to toggle this
	"set background=light
	set background=dark

	"colorscheme solarized
	call <SID>RandColorScheme()

else
	set mouse+=a
endif

" OS Detection
if is_win
	behave xterm
	set ffs=unix
	set backspace=2
	" options: set backspace=indent,eol,start
"elseif has('mac')
"	 ......
"elseif has('unix')
"	let matt='is_unix'
endif

""""""""""""""""""""" Git-Gutter """"""""""""""""""""""""
nmap ]h <Plug>GitGutterNextHunk
nmap [h <Plug>GitGutterPrevHunk
" stage the hunk with <Leader>hs or
" revert it with <Leader>hr.

" It appears I have to double toggle it to get git gutter to work
"GitGutterToggle
"GitGutterToggle
""""""""""""""""""""" /Git-Gutter """"""""""""""""""""""""

""""""""""""""""""""""" Ctrl-P """"""""""""""""""""""""
" Set up Ctrl-P shortcut key for Ctrl-P:
let g:ctrlp_map = '<c-k>'
let g:ctrlp_cmd = 'CtrlP'
map <c-m> :CtrlPTag<CR>

" Unmap center/<CR> from launching CTRL-P, because it's annoying
unmap <CR>
"""""""""""""""""""""" /Ctrl-P """"""""""""""""""""""""

" For vim-cpp-enhanced-highlight, turn on highlighting of class scope:
let g:cpp_class_scope_highlight = 1

" Tell vim to set the current directory to the directory
" of the file being opened:
set autochdir

" Tell vim to look for a tags file in the current
" directory, and all the way up until it finds one:
set tags=./tags;/

""""""""""""""""""""""" YCM Config """"""""""""""""""""""""
if has('unix')
	" Let YouCompleteMe use tag files for completion as well:
	let g:ycm_collect_identifiers_from_tags_files = 1

	" Turn off prompting to load .ycm_extra_conf.py:
	let g:ycm_confirm_extra_conf = 0

	" Map GetType to an easier key combination:
	nnoremap <leader>ty :YcmCompleter GetType<CR>

	" F2 will jump to a variable/method definition
	map <F2> :YcmCompleter GoTo<CR>

	nnoremap <leader>diag YcmDiag<CR>

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
		\ 'mail'      : 1
	\}

	let g:ycm_filetype_whitelist = {
		\ 'javascript': 1,
		\ 'python' : 1,
		\ 'css'    : 1,
		\ 'cpp'    : 1,
		\ 'php'    : 1,
		\ 'fortran': 1,
		\ 'xml'    : 1,
		\ 'html'   : 1,
	\}

	" Ignore large files (BONA db's for instance)
	let g:ycm_disable_for_files_larger_than_kb = 300

	" Shut off preview window on PHP files
	if (&ft ==? 'php')
		let g:ycm_add_preview_to_completeopt=0
	endif
	" Alternatively..
	"au BufNewFile,BufRead *.php let g:ycm_add_preview_to_completeopt=0

endif
"""""""""""""""""""""" /YCM Config """"""""""""""""""""""""

"""""""""""""""""""" Ultisnips config """"""""""""""""""""""
" Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
if is_win==0 && domain !=? 'school'
	let g:UltiSnipsExpandTrigger='<c-j>'
	let g:UltiSnipsJumpForwardTrigger='<c-j>'
	let g:UltiSnipsJumpBackwardTrigger='<c-n>'

	" If you want :UltiSnipsEdit to split your window.
	let g:UltiSnipsEditSplit='vertical'

	" Add to the runtime path so that custom
	" snippets can be found:
	set rtp+=~/dotfiles

	if domain ==? 'neptec'
		set rtp+=~/workspace/ScriptsAndTools
	endif
endif
""""""""""""""""""" /Ultisnips config """"""""""""""""""""""


""""""""""""""""""""" Airline Config """"""""""""""""""""""
" For vim-airline, ensure the status line is always displayed:
set laststatus=2

" Enable the list of buffers
"let g:airline#extensions#tabline#enabled = 1

" Show just the filename
let g:airline#extensions#tabline#fnamemod = ':t'

" Certain number of spaces are allowed after a tab (so, /**\n* comments can work
let g:airline#extensions#whitespace#mixed_indent_algo = 1
"""""""""""""""""""" /Airline Config """"""""""""""""""""""


""""""""""""""""""""" Tagbar Config """"""""""""""""""""""
" tagbar config. Enable it using this key map:
nmap <F8> :TagbarToggle<CR>
"""""""""""""""""""" /Tagbar Config """"""""""""""""""""""


""""""""""""""""""""" NERDTree """"""""""""""""""""""
" Shortcut key to open NERDTree:
map <F5> :NERDTreeToggle<CR>
let NERDTreeChDirMode = 2
nnoremap <leader>n :NERDTree .<CR>
"""""""""""""""""""" /NERDTree """"""""""""""""""""""

""""""""""""""""""""" BBye """"""""""""""""""""""
:nnoremap <Leader>q :Bdelete<CR>
""""""""""""""""""""" /BBye """"""""""""""""""""""

if is_win==0 && domain ==? 'neptec'

	"""""""""""""""""""" ctags """""""""""""""""""""""
	" A key map to run ctags:
	nnoremap <leader>ct :!ctags .<CR>
	"""""""""""""""""""" /ctags """"""""""""""""""""""

endif


"""""""""""""""""""" DBext """""""""""""""""""""""
" let g:dbext_default_profile_<profile_name> = '<connection string>'
" https://github.com/vim-scripts/dbext.vim
" https://mutelight.org/dbext-the-last-sql-client-youll-ever-need
let g:dbext_default_profile_3dri = 'type=SQLITE:dbname=/home/matt/workspace/opal2/3dri/Applications/OPAL2/3DRiWebScheduler/scan_schedule.db'
let g:dbext_default_profile_ademirs = 'type=SQLITE:dbname=/home/matt/tabletopics/ademir.db'
let g:dbext_default_profile_ademirm = 'type=MYSQL:user=ademir:passwd=ademir:dbname=ademir'
let g:dbext_default_profile_mayofest = 'type=MYSQL:user=www:passwd=hyper:dbname=mayofest'

augroup neptec
	au!
	autocmd BufRead */3dri/* DBSetOption profile='3dri'
augroup end

augroup mayofest
	au!
	autocmd BufRead */mayofest/* DBSetOption profile=mayofest
augroup end


map <leader>lt :DBListTable<CR>

nnoremap <leader>sel :DBListConnections<CR>
nnoremap <leader>dep :DBProfilesRefresh<CR>
"""""""""""""""""""" /DBext """"""""""""""""""""""


"""""""""""""""" Rainbow (foldering) """""""""""""""""""
	let g:rainbow_conf = {
	\   'guifgs': ['royalblue3', 'darkorange3', 'seagreen3', 'firebrick'],
	\   'ctermfgs': ['lightblue', 'lightyellow', 'lightcyan', 'lightmagenta'],
	\   'operators': '_,_',
	\   'parentheses': ['start=/(/ end=/)/ fold', 'start=/\[/ end=/\]/ fold', 'start=/{/ end=/}/ fold'],
	\   'separately': {
	\	   '*': {},
	\	   'tex': {
	\		   'parentheses': ['start=/(/ end=/)/', 'start=/\[/ end=/\]/'],
	\	   },
	\	   'lisp': {
	\		   'guifgs': ['royalblue3', 'darkorange3', 'seagreen3', 'firebrick', 'darkorchid3'],
	\	   },
	\	   'vim': {
	\		   'parentheses': ['start=/(/ end=/)/', 'start=/\[/ end=/\]/', 'start=/{/ end=/}/ fold', 'start=/(/ end=/)/ containedin=vimFuncBody', 'start=/\[/ end=/\]/ containedin=vimFuncBody', 'start=/{/ end=/}/ fold containedin=vimFuncBody'],
	\	   },
	\	   'html': {
	\		   'parentheses': ['start=/\v\<((area|base|br|col|embed|hr|img|input|keygen|link|menuitem|meta|param|source|track|wbr)[ >])@!\z([-_:a-zA-Z0-9]+)(\s+[-_:a-zA-Z0-9]+(\=("[^"]*"|'."'".'[^'."'".']*'."'".'|[^ '."'".'"><=`]*))?)*\>/ end=#</\z1># fold'],
	\	   },
	\	   'css': 0,
	\   }
	\}
"""""""""""""""" /Rainbow (foldering) """""""""""""""""""


"""""""""""""""" Whipeout """""""""""""""""""
" Source: http://stackoverflow.com/a/1536094/1861346
" @breif Remove all buffers not currently being displayed

function! Wipeout()
	" list of *all* buffer numbers
	let l:buffers = range(1, bufnr('$'))

	" what tab page are we in?
	let l:currentTab = tabpagenr()
	try
		" go through all tab pages
		let l:tab = 0
		while l:tab < tabpagenr('$')
			let l:tab += 1

			" go through all windows
			let l:win = 0
			while l:win < winnr('$')
				let l:win += 1
				" whatever buffer is in this window in this tab, remove it from
				" l:buffers list
				let l:thisbuf = winbufnr(l:win)
				call remove(l:buffers, index(l:buffers, l:thisbuf))
			endwhile
		endwhile

		" if there are any buffers left, delete them
		if len(l:buffers)
			execute 'bwipeout' join(l:buffers)
		endif
	finally
		" go back to our original tab page
		execute 'tabnext' l:currentTab
	endtry
endfunction
"""""""""""""""" /Whipeout """""""""""""""""""

"JSHintToggle

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

" Hide mouse when typing
set mousehide

" Easy save
noremap ^S :w<CR>
" map alt/apple or something-S for khea

" Remove trailing space
nnoremap <leader>rt :%s/\s\s*$//<CR>

" Ignore whitespace on vimdiff
if &diff
	" diff mode
	set diffopt+=iwhite
endif

" Map CTRL-Tab to change tab
noremap <C-S-Tab> <Esc>:tabprev<CR>
noremap <C-Tab> <Esc>:tabnext<CR>
" try to automatically fold xml
let xml_syntax_folding=1

" vim: ts=3 sts=3 sw=3 noet nowrap :
