" Needed for Vundles
set shell=/bin/bash

" Used for host detection
let hostname = substitute(system('hostname'), '\n', '', '')
let hostos = substitute(system('uname -o'), '\n', '', '')


if hostname ==? 'pof' || hostname ==? 'tinder' || hostname ==? 'grinder'
	let domain='neptec'
elseif matchstr(hostname, 'dena') ==? 'dena' || hostname ==? 'sahand' || hostname ==? 'pontus' || hostname ==? 'pontus.cee.carleton.ca'
	let domain='school'

" Can probably get rid of this...
elseif $TRUE_HOST !=? ''
	let domain='ec'
elseif hostname ==? 'tegra-ubuntu' || hostos ==? 'Cygwin'
	let domain='neptec-small'
elseif match(hostname, 'siteground') >= 0
	" Siteground is an exception because it uses vim 7.0
	let domain='siteground'
elseif match(hostname, 'khea') >= 0
	let domain='home'
else
	let domain='any'
endif
" echo 'Using domain ' . domain . ', hostname=' . hostname

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

" Set python
let g:python_host_prog  = '/usr/bin/python'
let g:python3_host_prog = '/usr/bin/python3'

set nocompatible             " be iMproved, required
filetype off                 " required


if empty(glob('~/.vim/autoload/plug.vim'))
	silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
	   \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Enable true colour support:
if has('termguicolors')
  set termguicolors
endif


call plug#begin('~/dotfiles/bundles')

if domain !=? 'neptec-small'
	" Solarized colour scheme
	Plug 'altercation/vim-colors-solarized'

	if domain !=? 'ec' && domain !=? 'neptec-small'
		" Atelier color scheme
		Plug 'atelierbram/vim-colors_atelier-schemes'
		" base16-atelierforest base16-atelierplateau base16-atelierheath base16-ateliercave base16-ateliersulphurpool base16-atelierlakeside base16-ateliersavanna base16-atelierseaside base16-atelierdune base16-atelierestuary

		" material
		Plug 'kristijanhusak/vim-hybrid-material'

		" Duotones
		Plug 'atelierbram/vim-colors_duotones'

		" Full of colour schemes:
		Plug 'flazz/vim-colorschemes'
		" Tomorrow Tomorrow-Night Tomorrow-Night-Eighties Tomorrow-Night-Bright Tomorrow-Night-Blue SlateDark PapayaWhip MountainDew Monokai Monokai-chris DevC++ c colorscheme_template colorful colorful256 colorer coldgreen coffee codeschool CodeFactoryv3 codeburn codeblocks_dark cobalt cobaltish clue cloudy clearance cleanroom cleanphp clarity ciscoacl chrysoprase chocolate ChocolatePapaya ChocolateLiquor chlordane chela_light Chasing_Logic charon charged-256 chance-of-storm cascadia carvedwood carvedwoodcool carrot caramel candy candyman candycode campfire camo calmar256-light cake16 C64 bw bvemu buttercream busybee busierbee burnttoast256 bubblegum brown brookstream breeze borland bog bocau bmichaelsen blugrine bluez blue blueshift blueprint bluegreen bluedrake bluechia blink blazer BlackSea blacklight blackdust blackboard blackbeauty black_angus biogoo billw bensday beauty256 beachcomber bclear bayQua baycomb basic base16-atelierdune badwolf babymate256 autumn autumnleaf automation atom asu1dark astronaut asmanian_blood ashen aqua apprentice ansi_blows anotherdark aiseered af advantage adrian adobe adaryn adam abra 3dglasses 256-jungle 256-grayvim 0x7A69_dark heliotrope habiLight h80 guepardo guardian gruvbox grishin greyblue grey2 greenvision greens grb256 graywh gravity grape gothic gotham gotham256 gor google golden golded gobo github getfresh getafe gentooish gemcolors gardener fu fruity fruit fruidle frood freya forneus fokus fog fnaqevan flatui flattr flatland flatlandia flatcolor fine_blue felipec far evening_2 enzyme emacs elrodeo elisex elise elda.vim* ekvoli ekinivim ego edo_sea editplus ecostation eclm_wombat eclipse earth earthburn earendel dusk dull dual doriath doorhinge donbass django distinguished disciple developer deveiate devbox-dark-256 detailed desert desertEx desertedocean desertedoceanburnt desert256 desert256v2 derefined denim delphi delek dawn darth darkZ darkzen darktango darkspectrum darkslategray dark-ruby darkroom darkrobot darkocean darker-robin darkerdesert darkeclipse darkdot darkburn darkbone darkBlue darkblue2 darkblack dante d8g_04 d8g_03 d8g_02 d8g_01 custom cthulhian corporation corn cool contrasty colorzone navajo-night nature native mustang muon mud mrpink mrkn256 motus moss moria mopkai mophiaSmoke mophiaDark montz monokain molokai mod_tcsoft mizore mint miko midnight midnight2 metacosm mellow mdark mayansmoke matrix martin_krischik mars maroloccio marklar manxome manuscript mango made_of_code mac_classic luna luinnar lucius louver lodestone lizard lizard256 literal_tango liquidcarbon lingodirector lilypink lilydjwg_green lilydjwg_dark lilac lightcolors leya lettuce less leo leglight2 legiblelight lazarus last256 landscape kyle kruby kolor kkruby kiss kib_plastic kib_darktango khaki kellys kate kalt kaltex kalisi jiks jhlight jhdark jellyx jellybeans jelleybeans jammy ironman ir_black inkpot ingretu industry industrial impact impactG iceberg icansee ibmedit iangenzo hybrid hybrid-light hornet holokai herokudoc herokudoc-gvim herald hemisu softblue softbluev2 smyck smp skittles_dark skittles_berry simplewhite simple_b simpleandfriendly simple256 silent sift sienna shobogenzo shadesofamber sf sexy-railscasts settlemyer seoul seoul256 seoul256-light selenitic sea seashell sean scite scala saturn satori sand rtl rootwater robinhood revolutions reloaded reliable relaxedgreen refactor redstring redblack rdark rdark-terminal rcg_term rcg_gui rastafari random rainbow_neon rainbow_fruit rainbow_fine_blue railscasts radicalgoodspeed quagmire python pyte pw putty psql pspad proton professional prmths print_bw potts pleasant playroom pink pic phpx phphaxor phd pf_earth perfect peppers pencil peaksea paintbox pacific otaku osx_like orange olive oceanlight oceandeep oceanblack oceanblack256 obsidian obsidian2 nuvola nour norwaytoday northsky northland no_quarter nightwish nightVision night_vision night nightsky nightshimmer nightflight nightflight2 nicotine newsprint newspaper nevfn neverness neverland neverland-darker neverland2 neverland2-darker neutron nerv-ous neon nefertiti nedit nedit2 nazca navajo zmrok zephyr zen zenesque zenburn zazen yeller yaml xterm16 xoria256 xmaslights xian xemacs wuye wood wombat wombat256 wombat256mod wombat256i winter wintersday win9xblueback widower whitedust whitebox watermark warm_grey wargrey vylight vydark void vj vividchalk visualstudio vilight vibrantink vexorian vc vcbc vanzan_color up underwater underwater-mod understated umber-green ubloh two2tango twitchy twilight twilight256 tutticolori turbo trogdor trivial256 transparent torte toothpik tony_light tomatosoup tolerable tir_black tidy tibet thor thestars thegoodluck textmate16 tetragrammaton tesla telstar tcsoft tchaba tchaba2 taqua tangoX tango tangoshady tango-morning tango-desert tango2 tabula synic symfony swamplight surveyor summerfruit summerfruit256 strawimodo strange stingray stackoverflow spring spiderhawk spectro southwest-fog southernlights soso sorcerer sonoma sonofobsidian sol sol-term solarized softlight
	endif

	" Other..
	Plug 'joshdick/onedark.vim'
	Plug 'arcticicestudio/nord-vim'
	Plug 'drewtempelmeyer/palenight.vim'
	Plug 'morhetz/gruvbox'
	Plug 'mhartington/oceanic-next'

	Plug 'ayu-theme/ayu-vim'
	let ayucolor="mirage"

endif

if is_win==0 && (domain ==? 'neptec' || domain ==? 'home')
	" YouCompleteMe
	Plug 'Valloric/YouCompleteMe'

	" YCMGenerator - generates configs for YouCompleteMe
	Plug 'rdnetto/YCM-Generator', {'branch': 'stable'}

	" tagbar - allows browsing tags of the current source file
	" from ctags. Good for seeing functions, variables, etc.
	Plug 'majutsushi/tagbar'
endif

if domain !=? 'neptec-small' && domain !=? 'school'
	" PHP Complete
	Plug 'shawncplus/phpcomplete.vim'
endif


if domain !=? 'neptec-small'
	" Install fzf, the fuzzy searcher
	Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
	Plug 'junegunn/fzf.vim'
endif

if is_win==0 && domain !=? 'ec' && domain !=? 'school'
	" Better C++ Syntax Highlighting:
	Plug 'octol/vim-cpp-enhanced-highlight'
endif

if is_win==0 && domain !=? 'ec' && domain !=? 'siteground'
	" Track the ultisnips engine.
	Plug 'SirVer/ultisnips'

	" Snippets are separated from the engine. Add this if you want them:
	Plug 'honza/vim-snippets'
endif

" Easy motion
" Plug 'easymotion/vim-easymotion'



if is_win==0 && (domain ==? 'neptec' || domain ==? 'home')

	""""""""""""""""""" vim-clang-format """""""""""""""""""""
	Plug 'rhysd/vim-clang-format'

	" Detect clang-format file
	let g:clang_format#detect_style_file = 1
	""""""""""""""""""" /vim-clang-format """"""""""""""""""""

	" Key mappings for clang-format, to format source code:
	autocmd FileType c,cpp,h,hpp nnoremap <buffer><Leader>fo :pyf /usr/share/vim/addons/syntax/clang-format.py<CR>
	autocmd FileType c,cpp,h,hpp nnoremap <buffer><Leader>f :<C-u>ClangFormat<CR>
	autocmd FileType c,cpp,h,hpp vnoremap <buffer><Leader>f :ClangFormat<CR>

	nmap <Leader>C :ClangFormatAutoToggle<CR>

	" neomake configuration
	let g:neomake_cpp_enabled_makers = ['clangtidy']
	let g:neomake_cpp_clangtidy_maker = {
		\ 'exe': '/usr/bin/clang-tidy',
		\ 'args': ['-checks=*' ],
		\}
	" Open error list automatically:
	let g:neomake_open_list = 2
	" Set up map for running Neomake:
	nnoremap <leader>n :Neomake<CR>

endif



" fugitive - a Git wrapper for vim. Also allows current
" git branch to be shown by vim-airline:
Plug 'tpope/vim-fugitive'
set diffopt+=vertical
" command GdiffOld exe "Gdiff develop:" . substitute(expand('%:p'), '/home/matt/workspace/opal2/3dri/Applications', 'Apps', 'g')
" command Gdiff1352n exe "Gdiff 1352-2-merge_in_gf:" . substitute(expand('%:p'), '/home/matt/workspace/opal2/3dri/Applications', 'Apps', 'g')
" command Gdiff1352o exe "Gdiff 1352_sdf_w_ground:" . substitute(expand('%:p'), '/home/matt/workspace/opal2/3dri/Apps', 'Applications', 'g')
" command Gdiffo exe "Gdiff v2.4.1:" . substitute(expand('%:p'), '/home/matt/workspace/opal2/3dri/Apps', 'Applications', 'g')
" command! Diffo exe "vertical diffsplit " . substitute(substitute(expand('%:p'), '/3dri/', '/3dri-2.4.0/', 'g'), '/Apps/', 'Applications', 'g')

" Used for navigating the quickfix window better.  Recommended by fugitive
Plug 'tpope/vim-unimpaired'

" Adding this so I can search/replace and preserve letter case
Plug 'tpope/vim-abolish'

if domain !=? 'school' && domain !=? 'ec'
	" gitgutter - Shows [git] status of each line in a file
	" On Dena, this injects annoying arroy key characters everywhere (e.g. ^[0D
	" ^[0B ^[0A ^[0C)

	" Toggle with :GitGutterToggle
	Plug 'airblade/vim-gitgutter'
endif

if domain !=? 'siteground'
	" Plug to assist with commenting out blocks of text:
	Plug 'tomtom/tcomment_vim'
endif

" Status bar
Plug 'powerline/powerline'

if domain !=? 'ec' && domain !=? 'school'
	" Switch between header and source files:
	" TODO Make filetype specific: http://stackoverflow.com/questions/6133341/can-you-have-file-type-specific-key-bindings-in-vim
	Plug 'derekwyatt/vim-fswitch'
endif

" Plug to help manage vim buffers:
" Plug 'jeetsukumaran/vim-buffergator'

" Plug to highlight the variable under the cursor:
" Appears to have been deleted off GitHub, still available at: http://www.vim.org/scripts/script.php?script_id=4306
" Plug 'OrelSokolov/HiCursorWords'

if domain !=? 'school' && domain !=? 'ec' && domain !=? 'neptec-small' && domain !=? 'siteground'
	" Doxygen
	Plug 'vim-scripts/DoxygenToolkit.vim'
endif

if domain !=? 'school' && domain !=? 'ec' && domain !=? 'neptec-small' && domain !=? 'siteground' && !is_win
	" A Plug to use rtags in vim. (rtags allows for code following,
	" some refactoring, etc.)
	" Ensure to run the following in the build directory that uses rtags
	"    cmake . -DCMAKE_EXPORT_COMPILE_COMMANDS=1
	"    rc -J .
	" And have the rdm service running somewhere in the background.
	Plug 'lyuts/vim-rtags'
endif

if domain !=? 'neptec-small' && domain !=? 'school' && domain !=? 'ec'
	" Colour coding nests
	Plug 'luochen1990/rainbow'
	let g:rainbow_active = 1 "0 if you want to enable it later via :RainbowToggle
endif

" Tabular, align equals
Plug 'godlygeek/tabular'

" Show markers
Plug 'kshenoy/vim-signature'

" Suppose to make closing splits better (less window resizing)

if domain !=? 'neptec-small' && domain !=? 'ec'
	" Python Syntax highlighting (the default is pretty bad)
	" For some reason this helps syntax highlighting in general though
	Plug 'Hdima/python-syntax'
endif

if domain !=? 'neptec-small'
	" Plug to wrap all the various grep tools, and provide
	" some more advanced search functionality
	Plug 'mhinz/vim-grepper'
endif

" Manage font size
if domain !=? 'neptec-small' && domain !=? 'ec' && domain !=? 'siteground'
	Plug 'drmikehenry/vim-fontsize'
endif

" Plugin to change the current directory to a project's root (so, look for
" .git or something)
if domain !=? 'siteground'
	Plug 'airblade/vim-rooter'
endif

" Javascript plugins to try
if domain !=? 'neptec-small' && domain !=? 'school' && domain !=? 'ec' && domain !=? 'siteground'
	Plug 'pangloss/vim-javascript'

	" General conceal settings. Will keep things concealed
	" even when your cursor is on top of them.
	Plug 'Wolfy87/vim-syntax-expand'
	set conceallevel=1
	set concealcursor=nvic

	" vim-javascript conceal settings.
	let g:javascript_conceal_function = "λ"
	let g:javascript_conceal_this = "@"
	let g:javascript_conceal_return = "<"
	let g:javascript_conceal_prototype = "#"
endif

" This should improve Git Fugitive and Git Gutter
Plug 'tmux-plugins/vim-tmux-focus-events'

if domain ==? 'neptec'
	Plug 'calincru/qml.vim'

	Plug 'benekastah/neomake' " Asynchronous linting
endif

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
Plug 'tpope/vim-eunuch'

" These are getting annoying, and aren't helping with tmux anyways
" Handle auto-calling mksession
" Plug 'tpope/vim-obsession'
" Plug 'dhruvasagar/vim-prosession'

if has('nvim')
	Plug 'vimlab/split-term.vim'
endif


if !has('gui_running') && !is_win && domain !=? 'siteground'
	" Plugin to get gvim colourschemes work better in terminal vim
	Plug 'godlygeek/csapprox'
endif

if domain !=? 'school'
	Plug 'tikhomirov/vim-glsl'
endif

" Plug 'othree/javascript-libraries-syntax.vim'
" Plug 'scrooloose/syntastic' " <-- using jshint for syntax

"if domain !=? 'school'
"	" Concurrent Editing
"	Plug 'floobits/floobits-neovim'
"endif

" Have vim reload a file if it has changed outside
" of vim:
if has('nvim')
	Plug 'TheZoq2/neovim-auto-autoread'
endif

Plug 'editorconfig/editorconfig-vim'

" All of your Plugins must be added before the following line
call plug#end()          " required


" TODO Put these in a pluggin
" Random Colorscheme
" TODO Add 'go to last colorschem'
" TODO Add 'mark as terrible colorscheme'
" TODO Add 'mark as good colorscheme'
function! s:RandColorScheme()
	if filereadable("/usr/bin/php")
		let s:scheme=system('/usr/bin/env php ~/dotfiles/grabRandomColorscheme.php')
		execute ':colorscheme '.s:scheme
		if has('gui_running')
			echom 'Loading colorscheme ' s:scheme
		endif
	endif
endfunction
:map <Leader>rcs :call <SID>RandColorScheme()<CR>

" Grab a random whitelisted colour scheme
function! s:RandWhiteListColorScheme()
	if filereadable("/usr/bin/php")
		let s:scheme=system('/usr/bin/env php ~/dotfiles/grabRandomColorscheme.php -w')
		execute ':colorscheme '.s:scheme
		echom 'Loading whitelist colorscheme ' s:scheme
	endif
endfunction
:map <Leader>wcs :call <SID>RandWhiteListColorScheme()<CR>

" Execute PHP lines http://stackoverflow.com/a/5622258/1861346
":autocmd FileType php noremap <C-M> :w!<CR>:!/usr/bin/php %<CR>

" Colour scheme
if has('gui_running')
	set mousemodel=popup
	set nomousehide

	" TODO Write a command to toggle this
	"set background=light
	set background=dark
else
	set mouse+=a
endif
set guicursor=

if domain ==? 'ec' || !filereadable("/usr/bin/php")
	colorscheme onedark
else
	call <SID>RandColorScheme()
endif

" OS Detection
if is_win
	behave xterm
	set ffs=unix
	set backspace=2

	if has('gui_running')
		" Typically windows is used with remote desktop from a smaller screen, so
		" the font is too big..
		GuiFont! Consolas:h10
	endif

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

	" Compile the file
	nnoremap <leader>y :YcmDiag<CR>

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
		\ 'mail'      : 1,
		\ 'frag'      : 1,
		\ 'vert'      : 1,
		\ 'comp'      : 1,
		\ 'qml'       : 1,
		\ 'tex'       : 1
	\}

	let g:ycm_filetype_whitelist = {
		\ 'javascript': 1,
		\ 'python' : 1,
		\ 'css'    : 1,
		\ 'cpp'    : 1,
		\ 'php'    : 1,
		\ 'fortran': 1,
		\ 'xml'    : 1,
		\ 'html'   : 1
	\}

	" Ignore large files (BONA db's for instance)
	let g:ycm_disable_for_files_larger_than_kb = 300

	" Shut off preview window on PHP files
	au BufNewFile,BufRead *.php let g:ycm_add_preview_to_completeopt=0

	" let g:ycm_path_to_python_interpreter = '/usr/bin/python'

	map <F9> :YcmCompleter FixIt<CR>
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

	augroup neptec-ultisnips
		au!
		autocmd BufRead */3dri* :set rtp+=~/workspace/ScriptsAndTools
		autocmd BufRead */pointcloud/* :set rtp+=~/workspace/ScriptsAndTools
	augroup end

endif
""""""""""""""""""" /Ultisnips config """"""""""""""""""""""


""""""""""""""""""""" Airline Config """"""""""""""""""""""
" For vim-airline, ensure the status line is always displayed:
set laststatus=2

" Show just the filename
let g:airline#extensions#tabline#fnamemod = ':t'

" Certain number of spaces are allowed after a tab (so, /**\n* comments can work
let g:airline#extensions#whitespace#mixed_indent_algo = 1
"""""""""""""""""""" /Airline Config """"""""""""""""""""""


""""""""""""""""""""" Tagbar Config """"""""""""""""""""""
" tagbar config. Enable it using this key map:
nmap <F8> :TagbarToggle<CR>
"""""""""""""""""""" /Tagbar Config """"""""""""""""""""""




if is_win==0 && domain ==? 'neptec'

	"""""""""""""""""""" ctags """""""""""""""""""""""
	" A key map to run ctags:
	nnoremap <leader>ct :!ctags .<CR>
	"""""""""""""""""""" /ctags """"""""""""""""""""""

endif


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


""""""""""""""""""""""" /fswitch """""""""""""""""""""""""
" Mapping for fswitch, to switch between header
" and source:
nmap <silent> <Leader>of :FSHere<cr>
""""""""""""""""""""""" /fswitch """""""""""""""""""""""""



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


"""""""""""""""" Wipeout """""""""""""""""""
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
"""""""""""""""" /Wipeout """""""""""""""""""


"""""""""""""" python-syntax """""""""""""""""
" No options yet..
""""""""""""" /python-syntax """""""""""""""""


"""""""""""""""""""""""""" fzf """""""""""""""""""""""""""
" Set up keyboard shortbuts for fzf, the fuzzy finder
" This one searches all the files in the current git repo:
noremap <c-k> :GitFiles<CR>
noremap <leader><Tab> :Buffers<CR>

" Unmap center/<CR> from launching fzf which appears to be mapped by default.
" unmap <CR>

""""""""""""""""""""""""" /fzf """""""""""""""""""""""""""


"""""""""""""""""""""" prosession  """"""""""""""""""""""""
" Options: https://github.com/dhruvasagar/vim-prosession/blob/master/doc/prosession.txt

"""""""""""""""""""""" /prosession """"""""""""""""""""""""

" Command to format Neptec's XML into valid XML
function! FixXML()
	exe "%s/<\\zs3/THREE/g"
	exe "%s#</\\zs3#THREE#g"

	exe '%s/\v(\w)\/(\w)/\1HHH\2/g'
	exe "%s/(/BBB/g"
	exe "%s/)/CCC/g"
endfunction
function! RevertXML()
	exe "%s/THREE/3/g"
	exe "%s#HHH#\/#g"
	exe "%s/BBB/(/g"
	exe "%s/CCC/)/g"
endfunction




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
set ffs=unix,dos

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

" Map CTRL-Tab to change tab
noremap <C-S-Tab> <Esc>:tabprev<CR>
noremap <C-Tab> <Esc>:tabnext<CR>
noremap <leader>tp <Esc>:tabprev<CR>
noremap <leader>tn <Esc>:tabnext<CR>

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

" ST term fucks up the delete key, seeing it as <F1>, so fixing it in vim for
" now (might fix it better elsewhere)
map <F1> x
imap <F1> <DEL>

" Map // to search for highlighted text. Source http://vim.wikia.com/wiki/Search_for_visually_selected_text
vnoremap // y/<C-R>"<CR>

" Match <> brackets
set matchpairs+=<:>

" " PHP Artisan commands
" if (&ft ==? 'php')
" 	abbrev gm !php artisan   generate:model
" 	abbrev gc !php artisan   generate:controller
" 	abbrev gmig !php artisan generate:migration
" endif

" try to automatically fold xml
let xml_syntax_folding=1

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

" vim: ts=3 sts=3 sw=3 noet nowrap :
