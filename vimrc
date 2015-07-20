"" {{{ bundles

if empty(glob('~/.vim/autoload/plug.vim'))
	silent !mkdir -p ~/.vim/{autoload,bundle,cache,undo,backups,swaps}
	silent !curl -fLo ~/.vim/autoload/plug.vim
		\ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	autocmd VimEnter * PlugInstall
endif

call plug#begin('~/.vim/bundle')
Plug 'Shougo/vimproc',                         {'do': 'make'}
Plug 'Shougo/echodoc'
if has('lua') && (version >= 704 || version == 703 && has('patch885'))
	Plug 'Shougo/neocomplete.vim'
	let g:completionEngine='neocomplete'
else
	" elseif has('lua')
	Plug 'Shougo/neocomplcache.vim'
	let g:completionEngine='neocomplcache'
endif
Plug 'Shougo/neosnippet'
Plug 'Shougo/neosnippet-snippets'
Plug 'scrooloose/syntastic'
Plug 'tpope/vim-endwise'
Plug 'Raimondi/delimitMate'

Plug 'tpope/vim-sensible'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-speeddating'
Plug 'haya14busa/incsearch.vim'
Plug 'terryma/vim-multiple-cursors'
Plug 'christoomey/vim-titlecase',              {'on': ['<Plug>Titlecase', '<Plug>TitlecaseLine']}
Plug 'junegunn/vim-easy-align',                {'on': ['<Plug>(EasyAlign)','<Plug>(LiveEasyAlign)']}

Plug 'kana/vim-textobj-user'
Plug 'kana/vim-textobj-indent'
Plug 'kana/vim-textobj-function'
Plug 'reedes/vim-textobj-sentence'
Plug 'wellle/targets.vim'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'justinmk/vim-sneak'
Plug 'tommcdo/vim-exchange'

Plug 'jeetsukumaran/vim-filebeagle'
Plug 'bling/vim-airline'
Plug 'jaxbot/browserlink.vim',                 {'for': ['html', 'javascript', 'css']}
Plug 'DanielFGray/DistractionFree.vim'
Plug 'sjl/gundo.vim',                          {'on': 'GundoToggle'}
Plug 'mhinz/vim-startify'
Plug 'mhinz/vim-tmuxify'
Plug 'junegunn/limelight.vim'
Plug 'reedes/vim-pencil'
Plug 'mhinz/vim-sayonara'

Plug 'mattn/webapi-vim'
Plug 'mattn/gist-vim',                         {'on': 'Gist'}
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'

Plug 'noahfrederick/vim-noctu'
Plug 'gosukiwi/vim-atom-dark'

Plug 'tejr/vim-tmux',                          {'for': 'tmux'}

Plug 'LaTeX-Box-Team/LaTeX-Box',               {'for': 'tex'}
Plug 'xuhdev/vim-latex-live-preview',          {'for': 'tex'}

Plug 'mattn/emmet-vim',                        {'for': ['html', 'xml', 'xsl', 'xslt', 'xsd', 'css', 'sass', 'scss', 'less', 'mustache', 'php']}
Plug 'Valloric/MatchTagAlways',                {'for': ['html', 'xhtml', 'xml', 'jinja']}
Plug 'tmhedberg/matchit',                      {'for': ['html', 'xml', 'xsl', 'xslt', 'xsd', 'css', 'sass', 'scss', 'less', 'mustache']}
Plug 'gregsexton/MatchTag',                    {'for': ['html', 'xml']}
Plug 'othree/html5.vim',                       {'for': 'html'}
Plug 'groenewege/vim-less',                    {'for': 'less'}
Plug 'hail2u/vim-css3-syntax',                 {'for': ['css', 'scss', 'sass']}
Plug 'digitaltoad/vim-jade',                   {'for': 'jade'}

Plug 'moll/vim-node',                          {'for': 'javascript'}
Plug 'jelera/vim-javascript-syntax',           {'for': 'javascript'}
Plug 'othree/yajs.vim',                        {'for': 'javascript'}
Plug 'othree/javascript-libraries-syntax.vim', {'for': 'javascript'}
Plug 'marijnh/tern_for_vim',                   {'for': 'javascript', 'do': 'npm install'}
Plug 'sheerun/vim-polyglot',                   {'for': 'javascript'}
Plug 'walm/jshint.vim',                        {'for': 'javascript'}
Plug 'heavenshell/vim-jsdoc',                  {'for': 'javascript'}

Plug 'raichoo/purescript-vim',                 {'for': 'purescript'}

Plug 'lukerandall/haskellmode-vim',            {'for': 'haskell'}
Plug 'raichoo/haskell-vim',                    {'for': 'haskell'}
Plug 'eagletmt/ghcmod-vim',                    {'for': 'haskell'}
Plug 'ujihisa/neco-ghc',                       {'for': 'haskell'}

Plug 'junegunn/fzf',                           {'dir': '~/.fzf', 'do': 'yes \| ./install'}
call plug#end()
"" }}}

"{{{ general settings
syntax on
filetype plugin indent on

"" TODO: more comments
set number
try | set relativenumber | catch | endtry
set colorcolumn=0
set cursorcolumn cursorline
set hlsearch incsearch
set infercase
set backspace=indent,eol,start
set nowrap
set showmatch
set equalalways
set splitright
set wildmenu wildcharm=<C-z>
set switchbuf=useopen,usetab
set tabstop=4 shiftwidth=4
set foldmethod=marker
set ruler rulerformat=%30(%=\:b%n%y%m%r%w\ %l,%c%V\ %P%)
set hidden
set list listchars=tab:\›\ ,trail:★,extends:»,precedes:«,nbsp:•
" set listchars+=eol:↵
set fillchars=stl:\ ,stlnc:\ ,vert:\ ,fold:\ ,diff:\ 
set showcmd
set noshowmode
set nolazyredraw
set autoread
set report=0
set confirm
set modeline modelines=2
set scrolloff=5
""set t_Co=16
set shortmess+=I
set ttimeoutlen=25
set background=dark
try
	set cryptmethod=blowfish
	set cryptmethod=blowfish2
catch | endtry
set sessionoptions-=options
set diffopt=vertical
set pastetoggle=<F6>
set undodir=~/.vim/undo/
set undofile
set undoreload=10000
set backupdir=~/.vim/backups/
set directory=~/.vim/swaps/
set undolevels=1000

if has("gui_running")
	colorscheme atom-dark-256
	set background=dark
	set guioptions-=L
	set guioptions-=r
	set guioptions-=b
	set guioptions-=T
	set guioptions-=m
	if has("gui_gtk2")
		set guifont=Tewi\ 9,DejaVu\ Sans\ Mono\ 8
	endif
else
	colorscheme noctu
endif
"}}}

"{{{ functions
function! InsertNewLine()
	execute "normal! i\<Return>"
endfunction

function! PromptQuit()
	echo 'close current buffer?'
	let char=nr2char(getchar())
	echo char
	if char=~'Y'
		silent execute "normal \<esc>:Sayonara\<cr>"
	elseif char=~'y'
		silent execute "normal \<esc>:Sayonara!\<cr>"
	endif
	silent! redraw!
endfunction

function! Togglegjgk()
	if !exists("g:togglegjgk") || g:togglegjgk==0
		let g:togglegjgk=1
		nnoremap j gj
		nnoremap k gk
		nnoremap gk k
		nnoremap gj j
		echo 'j/k swapped with gj/gk'
	else
		let g:togglegjgk=0
		nunmap j
		nunmap k
		nunmap gk
		nunmap gj
		echo 'normal j/k'
	endif
endfunction
"}}}

"{{{ autocmds
augroup VIM
	autocmd!
	autocmd BufRead,BufNewFile *.es6 setfiletype javascript
	autocmd BufWritePost ~/.vimrc,~/dotfiles/vimrc source ~/.vimrc | if exists(':AirlineRefresh') | execute 'AirlineRefresh' | endif
	autocmd BufWritePost ~/.tmux.conf,~/dotfiles/tmux.conf | if exists('$TMUX') | call system('tmux source-file ~/.tmux.conf && tmux display-message "Sourced .tmux.conf"') | endif
	autocmd VimResized * wincmd =
	autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | execute 'normal! g`"zvzz' | endif
	autocmd FileType markdown,mkd call pencil#init()                 | setlocal nocursorline nocursorcolumn
	autocmd FileType text         call pencil#init({'wrap': 'hard'}) | setlocal nocursorline nocursorcolumn
	autocmd FileType help wincmd L | vert resize 80
	autocmd FileType vim nnore <silent><buffer> K <Esc>:help <C-R><C-W><CR>
	autocmd FileType vim-plug setlocal nonu nornu nolist
	if exists('*termopen')
		autocmd TermOpen * setlocal nolist nocursorline nocursorcolumn
	endif
augroup END
"}}}

"{{{ maps
let g:mapleader="\<Space>"
nnoremap Y y$
cnoremap %% <C-R>=fnameescape(expand('%:h')).'/'<CR>
command! -bar -nargs=* -complete=help H :vert help <args>
cabbrev w!! w !sudo tee >/dev/null "%"
nnoremap <silent> Q <Esc>:call PromptQuit()<CR>
nnoremap <silent> <Return> <Esc>:call InsertNewLine()<CR>
nnoremap <silent> <leader>tgj <Esc>:call Togglegjgk()<CR>
"}}}

"" {{{ motions
let g:sneak#prompt='(sneak)» '
map <silent> f <Plug>Sneak_f
map <silent> F <Plug>Sneak_F
map <silent> t <Plug>Sneak_t
map <silent> T <Plug>Sneak_T
map <silent> ; <Plug>SneakNext
map <silent> , <Plug>SneakPrevious
augroup SneakPluginColors
	autocmd!
	autocmd ColorScheme * hi SneakPluginTarget guifg=black guibg=red ctermfg=black ctermbg=red
	autocmd ColorScheme * hi SneakPluginScope  guifg=black guibg=yellow ctermfg=black ctermbg=yellow
augroup END

map + <Plug>(wildfire-fuel)
map _ <Plug>(wildfire-water)
"" }}}

"" {{{ searching
let g:incsearch#consistent_n_direction=1
let g:incsearch#auto_nohlsearch=1
let g:incsearch#magic='\v'
map /  <Plug>(incsearch-forward)
map ?  <Plug>(incsearch-backward)
map g/ <Plug>(incsearch-stay)
map n  <Plug>(incsearch-nohl-n)zvzz
map N  <Plug>(incsearch-nohl-N)zvzz
map *  <Plug>(incsearch-nohl-*)
map #  <Plug>(incsearch-nohl-#)
map g* <Plug>(incsearch-nohl-g*)
map g# <Plug>(incsearch-nohl-g#)

function! Multiple_cursors_before()
	if exists(':NeoCompleteLock')==2
		exe 'NeoCompleteLock'
	endif
endfunction

" Called once only when the multiple selection is canceled (default <Esc>)
function! Multiple_cursors_after()
	if exists(':NeoCompleteUnlock')==2
		exe 'NeoCompleteUnlock'
	endif
endfunction
"" }}}

"" {{{ auto completion
if exists('g:completionEngine')
	let g:acp_enableAtStartup=0
	let g:{g:completionEngine}#enable_at_startup=1
	let g:{g:completionEngine}#enable_smart_case=1
	let g:{g:completionEngine}#sources#syntax#min_keyword_length=3
	let g:{g:completionEngine}#auto_completion_start_length=3
	let g:{g:completionEngine}#sources#dictionary#dictionaries={  'default' : '' }
	let g:{g:completionEngine}#sources#omni#input_patterns={}
	let g:{g:completionEngine}#keyword_patterns={ 'default': '\h\w*' }
	let g:{g:completionEngine}#data_directory="~/.vim/cache/neocomplete"
	inoremap <expr><C-g>     {g:completionEngine}#undo_completion()
	inoremap <expr><C-l>     {g:completionEngine}#complete_common_string()
	inoremap <expr><BS>      {g:completionEngine}#smart_close_popup()."\<C-h>"
	inoremap <expr><TAB>     pumvisible() ? "\<C-n>" : "\<TAB>"
endif
"" "}}}

"" {{{ snippets
let g:neosnippet#snippets_directory='~/.vim/bundle/vim-snippets/snippets,~/.vim/snippets'
imap <C-k> <Plug>(neosnippet_expand_or_jump)
smap <C-k> <Plug>(neosnippet_expand_or_jump)
xmap <C-k> <Plug>(neosnippet_expand_target)
imap <expr><TAB> neosnippet#expandable_or_jumpable() ?
\	"\<Plug>(neosnippet_expand_or_jump)"
\	: pumvisible() ? "\<C-n>" : "\<TAB>"
smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
\	"\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"
if has('conceal')
	set conceallevel=2 concealcursor=i
endif
"" }}}

"" {{{ syntax checking
let g:syntastic_enable_signs=1
let g:syntastic_auto_loc_list=1
let g:syntastic_check_on_open=1
let g:syntastic_error_symbol='✗'
let g:syntastic_style_error_symbol='✠'
let g:syntastic_warning_symbol='∆'
let g:syntastic_style_warning_symbol='≈'
let g:syntastic_html_tidy_ignore_errors=[' proprietary attribute "ng-']
if(executable('eslint'))
	let g:syntastic_javascript_checkers=['eslint']
endif

let g:echodoc_enable_at_startup=1
"" }}}

"" {{{ tmux integration
let g:tmuxify_custom_command='tmux split-window -d -v -p 25'
let g:tmuxify_global_maps=1
let g:tmuxify_run={
	\ 'lilypond':   ' for file in %; do; lilypond $file; x-pdf "${file[@]/%ly/pdf}"; done',
	\ 'tex':        ' for file in %; do; texi2pdf $file; x-pdf "${file[@]/%tex/pdf}"; done',
	\ 'ruby':       ' ruby %',
	\ 'python':     ' python %',
	\ 'javascript': ' node %'
\}
"" }}}

"" {{{ gundo settings
nnoremap <F5> :GundoToggle<CR>
let g:gundo_right=1
let g:gundo_width=60
let g:gundo_preview_height=20
"" }}}

"" {{{ git integration
nnoremap <leader>gs <Esc>:Gstatus<CR>
nnoremap <leader>gd <Esc>:Gdiff<CR>
nnoremap <leader>gc <Esc>:Gcommit<CR>
nnoremap <leader>gb <Esc>:Gblame<CR>
nnoremap <leader>gl <Esc>:Glog<CR>
nnoremap <leader>gp <Esc>:Git push<CR>
nnoremap <leader>gu <Esc>:Git pull<CR>
"" }}}

"" {{{ status line
let g:airline_theme='hybridline'
let g:airline_powerline_fonts=1
let g:airline#extensions#whitespace#enabled=0
let g:airline#extensions#branch#enabled=1
let g:airline#extensions#tabline#enabled=1
let g:airline#extensions#tabline#fnamemod=':t'
function! AirlineInit()
	let g:airline_section_z=g:airline_section_y
	let g:airline_section_y=g:airline_section_x
	let g:airline_section_x=''
endfunction
autocmd User AirlineAfterInit call AirlineInit()
"" }}}

"" {{{ misc plugins
nmap <Leader>a <Plug>(EasyAlign)
vmap <Leader>a <Plug>(EasyAlign)

let g:titlecase_map_keys=0
nmap <silent> <leader>gt <Plug>Titlecase
vmap <silent> <leader>gt <Plug>Titlecase
nmap <silent> <leader>gT <Plug>TitlecaseLine

let g:distraction_free#toggle_tmux=1
let g:distraction_free#toggle_limelight=1
noremap <leader>df <Esc>:DistractionsToggle<CR>

nnoremap <leader>jd <Plug>(jsdoc)

let g:limelight_conceal_ctermfg='DarkGray'

let g:pencil#wrapModeDefault='soft'
let g:pencil#textwidth=80

let g:filebeagle_suppress_keymaps = 1
map <silent> - <Plug>FileBeagleOpenCurrentBufferDir

if has('nvim')
	let g:startify_custom_header=[
	\ '        ┏┓╻┏━╸┏━┓╻ ╻╻┏┳┓',
	\ '        ┃┗┫┣╸ ┃ ┃┃┏┛┃┃┃┃',
	\ '        ╹ ╹┗━╸┗━┛┗┛ ╹╹ ╹',
	\ '']
else
	let g:startify_custom_header=[
	\ '        ╻ ╻╻┏┳┓',
	\ '        ┃┏┛┃┃┃┃',
	\ '        ┗┛ ╹╹ ╹',
	\ '']
endif
"" }}}

source ~/dotfiles/fzf.vim
