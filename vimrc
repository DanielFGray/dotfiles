" TODO: more comments
filetype plugin indent on
let g:mapleader="\<Space>"

" {{{ plugins
if empty(glob('~/.vim/autoload/plug.vim'))
	silent !mkdir -p ~/.vim/{autoload,bundle,cache,undo,backups,swaps}
	silent !curl -fLo ~/.vim/autoload/plug.vim
		\ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	autocmd VimEnter * PlugInstall
endif

call plug#begin('~/.vim/bundle')
Plug 'junegunn/fzf',                           {'dir': '~/.fzf', 'do': 'yes \| ./install'}
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-speeddating'
" Plug 'tpope/vim-sleuth'
Plug 'vim-utils/vim-husk'
Plug 'junegunn/fzf.vim' " {{{
	nnoremap <silent> <leader>f :Files<CR>
	nnoremap <silent> <leader>b :Buffers<CR>
	nnoremap <silent> <leader>: :Commands<CR>
	nnoremap <silent> <leader>? :History<CR>
	nnoremap <silent> <leader>/ :execute 'Ag ' . input('Ag/')<CR>
	nnoremap <silent> <leader>gl :Commits<CR>
	nnoremap <silent> <leader>ga :BCommits<CR>
" }}}
" {{{ Plug 'Shougo/neocomp(lete|lcache)'
" if has('nvim') Plug 'Shougo/deoplete.nvim' else
if has('lua') && (version >= 704 || version == 703 && has('patch885'))
	Plug 'Shougo/neocomplete.vim'
	let g:completionEngine='neocomplete'
elseif has('lua')
	Plug 'Shougo/neocomplcache.vim'
	let g:completionEngine='neocomplcache'
endif
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
" }}}
Plug 'Shougo/neosnippet' " {{{
Plug 'Shougo/neosnippet-snippets'
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
" }}}
Plug 'Shougo/vimproc',                         {'do': 'make'}
Plug 'Shougo/echodoc'
Plug 'scrooloose/syntastic' " {{{
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
" }}}
Plug 'Raimondi/delimitMate' " {{{
let delimitMate_expand_cr = 1
let delimitMate_jump_expansion = 1
" }}}
Plug 'christoomey/vim-titlecase' " {{{
	let g:titlecase_map_keys=0
	nmap <silent> <leader>gt <Plug>Titlecase
	vmap <silent> <leader>gt <Plug>Titlecase
	nmap <silent> <leader>gT <Plug>TitlecaseLine
" }}}
Plug 'junegunn/vim-easy-align' " {{{
	nmap <Leader>a <Plug>(EasyAlign)
	vmap <Leader>a <Plug>(EasyAlign)
" }}}

Plug 'justinmk/vim-sneak' " {{{
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
" }}}
Plug 'haya14busa/incsearch.vim' " {{{
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
" }}}
Plug 'terryma/vim-multiple-cursors' " {{{
	function! Multiple_cursors_before()
		if exists(':NeoCompleteLock')==2
			NeoCompleteLock
		endif
	endfunction
	function! Multiple_cursors_after()
		if exists(':NeoCompleteUnlock')==2
			NeoCompleteUnlock
		endif
	endfunction
" }}}
Plug 'kana/vim-textobj-user'
Plug 'kana/vim-textobj-indent'
Plug 'kana/vim-textobj-function'
Plug 'reedes/vim-textobj-sentence'
Plug 'thinca/vim-textobj-between'
Plug 'wellle/targets.vim'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'tommcdo/vim-exchange'

Plug 'jeetsukumaran/vim-filebeagle' " {{{
	let g:filebeagle_suppress_keymaps = 1
	map <silent> - <Plug>FileBeagleOpenCurrentBufferDir
" }}}
Plug 'bling/vim-airline' " {{{
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
" }}}
Plug 'DanielFGray/DistractionFree.vim' " {{{
	let g:distraction_free#toggle_tmux=1
	let g:distraction_free#toggle_limelight=1
	noremap <leader>df <Esc>:DistractionsToggle<CR>
" }}}
Plug 'sjl/gundo.vim' " {{{
	nnoremap <F5> :GundoToggle<CR>
	let g:gundo_right=1
	let g:gundo_width=60
	let g:gundo_preview_height=20
" }}}
Plug 'mhinz/vim-startify' " {{{
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
" }}}
Plug 'mhinz/vim-tmuxify' " {{{
	let g:tmuxify_custom_command='tmux split-window -d -v -p 25'
	let g:tmuxify_global_maps=1
	let g:tmuxify_run={
		\ 'lilypond':   ' for file in %; do; lilypond $file; x-pdf "${file[@]/%ly/pdf}"; done',
		\ 'tex':        ' for file in %; do; texi2pdf $file; x-pdf "${file[@]/%tex/pdf}"; done',
		\ 'ruby':       ' ruby %',
		\ 'python':     ' python %',
		\ 'javascript': ' node %'
	\}
" }}}
Plug 'junegunn/limelight.vim' " {{{
	let g:limelight_conceal_ctermfg='DarkGray'
" }}}
Plug 'reedes/vim-pencil' " {{{
	let g:pencil#wrapModeDefault='soft'
	let g:pencil#textwidth=80
" }}}
Plug 'mhinz/vim-sayonara'
Plug 'sheerun/vim-polyglot'
Plug 'Shougo/neomru.vim'
Plug 'noahfrederick/vim-noctu'
Plug 'gosukiwi/vim-atom-dark'

Plug 'tpope/vim-fugitive' " {{{
	nnoremap <leader>gs <Esc>:Gstatus<CR>
	nnoremap <leader>gd <Esc>:Gdiff<CR>
	nnoremap <leader>gc <Esc>:Gcommit<CR>
	nnoremap <leader>gb <Esc>:Gblame<CR>
	nnoremap <leader>gl <Esc>:Glog<CR>
	nnoremap <leader>gp <Esc>:Git push<CR>
	nnoremap <leader>gu <Esc>:Git pull<CR>
" }}}
Plug 'airblade/vim-gitgutter'
Plug 'mattn/webapi-vim'
Plug 'mattn/gist-vim'
Plug 'esneider/YUNOcommit.vim'

Plug 'LaTeX-Box-Team/LaTeX-Box'
Plug 'xuhdev/vim-latex-live-preview'
Plug 'suan/vim-instant-markdown'
Plug 'jaxbot/browserlink.vim',                 {'for': ['html', 'javascript', 'css']}

Plug 'mattn/emmet-vim'
Plug 'Valloric/MatchTagAlways'
Plug 'tmhedberg/matchit'
Plug 'othree/html5.vim'
Plug 'groenewege/vim-less'
Plug 'hail2u/vim-css3-syntax'
Plug 'digitaltoad/vim-jade'
Plug 'ap/vim-css-color'
Plug 'tpope/vim-liquid'
Plug 'tpope/vim-ragtag'

Plug 'moll/vim-node'
Plug 'othree/javascript-libraries-syntax.vim'
Plug 'marijnh/tern_for_vim'
Plug 'walm/jshint.vim'
Plug 'heavenshell/vim-jsdoc'

Plug 'lukerandall/haskellmode-vim'
Plug 'raichoo/purescript-vim'
Plug 'eagletmt/ghcmod-vim'
Plug 'ujihisa/neco-ghc'

call plug#end()
" }}}

" {{{ general settings
syntax on

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
" set t_Co=16
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
" }}}

" {{{ functions

function! PromptQuit() " {{{
	echo 'close current buffer?'
	let char=nr2char(getchar())
	echo char
	if char=~'Y'
		Sayonara
	elseif char=~'y'
		Sayonara!
	endif
	silent! redraw!
endfunction " }}}

function! Togglegjgk() " {{{
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
" }}}

function! s:readurl(url) " {{{
	enew
	silent execute "read !curl -sL " . a:url
	normal ggdd
endfunction
" }}}

function! s:get_visual_selection() " {{{
	" http://stackoverflow.com/a/6271254/570760
	let [lnum1, col1]=getpos("'<")[1:2]
	let [lnum2, col2]=getpos("'>")[1:2]
	let lines=getline(lnum1, lnum2)
	let lines[-1]=lines[-1][: col2 - (&selection == 'inclusive' ? 1 : 2)]
	let lines[0]=lines[0][col1 - 1:]
	return join(lines, "\n")
endfunction
" }}}

function! s:sprunge(line1, line2) " {{{
	echo 'Uploading..'
	let l:content=''
	if(a:line1 == line("'<'") || a:line2 == line("'>'"))
		let l:content=s:get_visual_selection()
	else
		let l:content=join(getline(a:line1, a:line2), "\n")
	endif
	let l:url = system('curl -sF "sprunge=<-" http://sprunge.us', l:content)[0:-2]
	redraw
	if(empty(l:url))
		echomsg 'Failed'
		return false
	endif
	echomsg l:url
endfunction
" }}}

function! AdjustWindowHeight(minheight, maxheight) " {{{
	exe max([min([line("$"), a:maxheight]), a:minheight]) . "wincmd _"
endfunction
" }}}

function! s:DiffWithSaved() " {{{
	let filetype=&ft
	diffthis
	vnew | r # | normal! 1Gdd
	diffthis
	exe "setlocal bt=nofile bh=wipe nobl noswf ro ft=" . filetype
endfunction
" }}}

" }}}

" {{{ autocmds
augroup VIM
	autocmd!
	autocmd BufRead,BufNewFile *.es6        setfiletype javascript
	autocmd BufWritePost       *vimrc       source ~/.vimrc | if exists(':AirlineRefresh') | execute 'AirlineRefresh' | endif
	autocmd BufWritePost       *tmux.conf   if exists('$TMUX') | call system('tmux source-file ~/.tmux.conf && tmux display-message "Sourced .tmux.conf"') | endif
	autocmd FileType           javascript   nnoremap <leader>jd <Plug>(jsdoc)
	autocmd BufReadPost        *            if line("'\"") > 0 && line("'\"") <= line("$") | execute 'normal! g`"zvzz' | endif
	autocmd FileType           markdown,mkd call pencil#init()                 | setlocal nocursorline nocursorcolumn
	autocmd FileType           text         call pencil#init({'wrap': 'hard'}) | setlocal nocursorline nocursorcolumn
	autocmd FileType           qf           call AdjustWindowHeight(3, 30)
	autocmd FileType           help         nnoremap <buffer> q <esc>:Sayonara<cr>
	autocmd FileType           help         wincmd L | vert resize 80
	autocmd BufEnter           *            if &filetype=='help' | execute 'normal 0' | vert resize 80 | endif
	autocmd BufLeave           *            if &filetype=='help' | execute 'normal 0' | vert resize 10 | endif
	autocmd FileType           vim          setlocal keywordprg=:help
	autocmd FileType           vim-plug     setlocal nonu nornu nolist nocursorline nocursorcolumn
	if exists('*termopen')
		autocmd TermOpen * setlocal nolist nocursorline nocursorcolumn
		autocmd BufEnter * if &buftype=='terminal' | startinsert | endif
	endif
augroup END
" }}}

" {{{ commands and maps
nnoremap Y y$
nnoremap <silent> Q <Esc>:call PromptQuit()<CR>
nnoremap <silent> <leader>tgj <Esc>:call Togglegjgk()<CR>
cnoremap %% <C-R>=fnameescape(expand('%:h')).'/'<CR>
cabbrev w!! w !sudo tee >/dev/null "%"
command! -bar -nargs=1 R call s:readurl("<args>")
command! -bar -nargs=0 -range=% Sprunge call s:sprunge(<line1>, <line2>)
command! DiffSaved call s:DiffWithSaved()
" }}}
