"" {{{ bundles
set runtimepath+=~/.vim/bundle/neobundle.vim/
call neobundle#begin(expand('~/.vim/bundle/'))
NeoBundleFetch 'Shougo/neobundle.vim'
NeoBundle      'Shougo/vimproc',                         {'name': 'vimproc', 'build': {'unix': 'make -f make_unix.mak'}}
NeoBundle      'Shougo/unite.vim',                       {'name': 'unite.vim', 'depends': 'vimproc'}
NeoBundleLazy  'thinca/vim-unite-history',               {'depends': 'unite.vim', 'autoload': {'unite_sources': 'history/command'}}
NeoBundleLazy  'Shougo/unite-help',                      {'depends': 'unite.vim', 'autoload': {'unite_sources': 'help'}}
NeoBundleLazy  'Shougo/unite-outline',                   {'depends': 'unite.vim', 'autoload': {'unite_sources': 'outline'}}
NeoBundleLazy  'Shougo/unite-session',                   {'depends': 'unite.vim', 'autoload': {'unite_sources': 'session', 'commands': ['UniteSessionSave', 'UniteSessionLoad']}}
NeoBundleLazy  'Shougo/neomru.vim',                      {'depends': 'unite.vim', 'autoload': {'unite_sources': 'file_mru'}}
NeoBundleLazy  'tsukkee/unite-tag',                      {'depends': 'unite.vim', 'autoload': {'unite_sources': ['tag', 'tag/file']}}
NeoBundle      'osyo-manga/unite-filetype',              {'depends': 'unite.vim'}
NeoBundle      'Shougo/context_filetype.vim'
NeoBundle      'Shougo/echodoc'
NeoBundle      'Shougo/neocomplete.vim'
NeoBundle      'Shougo/neosnippet'
NeoBundle      'Shougo/neosnippet-snippets'
NeoBundle      'Shougo/vimfiler'

NeoBundle      'scrooloose/syntastic'
NeoBundle      'terryma/vim-expand-region'
NeoBundle      'wellle/targets.vim'
NeoBundle      'junegunn/vim-easy-align'
NeoBundle      'tpope/vim-fugitive'
NeoBundle      'tpope/vim-surround'
NeoBundle      'tpope/vim-abolish'
NeoBundle      'tpope/vim-unimpaired'
NeoBundle      'tpope/vim-repeat'
NeoBundle      'tpope/vim-vinegar'
NeoBundle      'mhinz/vim-startify'
NeoBundle      'mhinz/vim-tmuxify'
NeoBundle      'bling/vim-airline'
NeoBundle      'sjl/gundo.vim'
NeoBundleLazy  'kana/vim-textobj-user',                  {'name': 'vim-textobj-user'}
NeoBundleLazy  'reedes/vim-textobj-sentence',            {'depends': 'vim-textobj-user'}
NeoBundleLazy  'kana/vim-textobj-function',              {'depends': 'vim-textobj-user'}
NeoBundleLazy  'christoomey/vim-titlecase',              {'autoload': {'mappings': ['<Plug>Titlecase', '<Plug>TitlecaseLine']}}
NeoBundle      'zhaocai/GoldenView.Vim'
NeoBundle      'noahfrederick/vim-noctu'
NeoBundleLazy  'Shougo/vimshell.vim',                    {'autoload': {'commands': [{'name': 'VimShell', 'complete': 'customlist,vimshell#complete'}, 'VimShellExecute', 'VimShellInteractive', 'VimShellTerminal', 'VimShellPop']}}
NeoBundle      'Keithbsmiley/investigate.vim'
NeoBundle      'Raimondi/delimitMate'
NeoBundleLazy  'haya14busa/incsearch.vim',               {'autoload': {'mappings': ['<Plug>(incsearch-']}}
NeoBundleLazy  'jaxbot/browserlink.vim',                 {'autoload': {'filetypes': ['html', 'javascript', 'css']}}
NeoBundleLazy  'mattn/gist-vim',                         {'depends': 'mattn/webapi-vim'}

NeoBundleLazy  'LaTeX-Box-Team/LaTeX-Box',               {'autoload': {'filetypes': ['tex']}}
NeoBundleLazy  'xuhdev/vim-latex-live-preview',          {'autoload': {'filetypes': ['tex']}}

NeoBundleLazy  'mattn/emmet-vim',                        {'autoload': {'filetypes': ['html', 'xml', 'xsl', 'xslt', 'xsd', 'css', 'sass', 'scss', 'less', 'mustache']}}
NeoBundleLazy  'Valloric/MatchTagAlways',                {'autoload': {'filetypes': ['html', 'xhtml', 'xml', 'jinja']}}
NeoBundleLazy  'tmhedberg/matchit',                      {'autoload': {'filetypes': ['html', 'xml', 'xsl', 'xslt', 'xsd', 'css', 'sass', 'scss', 'less', 'mustache']}}
NeoBundleLazy  'gregsexton/MatchTag',                    {'autoload': {'filetypes': ['html', 'xml']}}
NeoBundleLazy  'othree/html5.vim',                       {'autoload': {'filetypes': ['html']}}
NeoBundleLazy  'groenewege/vim-less',                    {'autoload': {'filetypes': ['less']}}
NeoBundleLazy  'hail2u/vim-css3-syntax',                 {'autoload': {'filetypes': ['css', 'scss', 'sass']}}
NeoBundleLazy  'digitaltoad/vim-jade',                   {'autoload': {'filetypes': ['jade']}}

NeoBundleLazy  'moll/vim-node',                          {'autoload': {'filetypes': ['javascript']}}
NeoBundleLazy  'jelera/vim-javascript-syntax',           {'autoload': {'filetypes': ['javascript']}}
NeoBundleLazy  'othree/javascript-libraries-syntax.vim', {'autoload': {'filetypes': ['javascript']}}
NeoBundleLazy  'burnettk/vim-angular',                   {'autoload': {'filetypes': ['javascript']}}
NeoBundleLazy  'marijnh/tern_for_vim',                   {'autoload': {'filetypes': ['javascript']}, 'build': {'unix': 'npm install'}}
NeoBundleLazy  'pangloss/vim-javascript',                {'autoload': {'filetypes': ['javascript']}}
NeoBundleLazy  'sheerun/vim-polyglot',                   {'autoload': {'filetypes': ['javascript']}}
NeoBundleLazy  'walm/jshint.vim',                        {'autoload': {'filetypes': ['javascript']}}
NeoBundleLazy  'kchmck/vim-coffee-script',               {'autoload': {'filetypes': ['coffee']}}
NeoBundleCheck
call neobundle#end()
"" }}}

syntax on
filetype plugin indent on

"" TODO: more comments
set number
set relativenumber
set colorcolumn=80
set cursorcolumn cursorline
set laststatus=2
set hlsearch
set incsearch
set infercase
set backspace=indent,eol,start
set nowrap
set showmatch
set equalalways
set splitright
set wildmenu
set wildcharm=<C-z>
set switchbuf=useopen,usetab
set autoindent smartindent smarttab
set tabstop=4 softtabstop=4 shiftwidth=4
set foldmethod=marker
set ruler
set rulerformat=%30(%=\:b%n%y%m%r%w\ %l,%c%V\ %P%)
set hidden
set list
set fillchars+=vert:│
set listchars=tab:\|\ ,eol:★,trail:◥,extends:>,precedes:<,nbsp:.
set showcmd
set mouse=a
set nolazyredraw
set autoread
set report=0
set confirm
set modeline
set modelines=2
set scrolloff=5
set t_Co=16
set shortmess+=I
set ttimeoutlen=25
set background=dark
set cryptmethod=blowfish
set sessionoptions=blank,buffers,curdir,help,resize,tabpages,winsize,winpos
set diffopt=vertical
set pastetoggle=<F6>
colorscheme noctu

noremap ; :
noremap : ;
nnoremap Y y$
nnoremap n nzzzv
nnoremap N Nzzzv
vnoremap < <gv
vnoremap > >gv
cnoremap vh vert h 
ca w!! w !sudo tee >/dev/null "%"

if version >= 703
	if exists("&undodir")
		set undodir=~/.vim/undo//
	endif
	set undofile
	set undoreload=10000
endif
if exists("&backupdir")
	set backupdir=~/.vim/backups//
endif
if exists("&directory")
	set directory=~/.vim/swaps//
endif
set undolevels=1000

"" {{{ auto completion
set ofu=syntaxcomplete#Complete
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript    setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python        setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml           setlocal omnifunc=xmlcomplete#CompleteTags
autocmd FileType css           setlocal omnifunc=csscomplete#CompleteCSS
let g:acp_enableAtStartup = 0
let g:neocomplete#enable_at_startup = 1
let g:neocomplete#enable_smart_case = 1
let g:neocomplete#sources#syntax#min_keyword_length = 3
let g:neocomplete#auto_completion_start_length = 3
let g:neocomplete#sources#dictionary#dictionaries = {  'default' : '' }
if !exists('g:neocomplete#sources#omni#input_patterns')
  let g:neocomplete#sources#omni#input_patterns = {}
endif
if !exists('g:neocomplete#keyword_patterns')
    let g:neocomplete#keyword_patterns = {}
endif
let g:neocomplete#keyword_patterns['default'] = '\h\w*'
inoremap <expr><C-g>     neocomplete#undo_completion()
inoremap <expr><C-l>     neocomplete#complete_common_string()
inoremap <expr><BS>      neocomplete#smart_close_popup()."\<C-h>"
inoremap <expr><TAB>     pumvisible() ? "\<C-n>" : "\<TAB>"
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

"" {{{ unite.vim settings
let g:unite_data_directory = '~/.vim/cache/unite'
let g:unite_prompt = '» '
let g:unite_source_history_yank_enable = 1
let g:unite_winheight = 10
let g:unite_split_rule = 'botright'
let g:unite_force_overwrite_statusline = 0
call unite#custom#profile('default', 'context', { 'start_insert': 1 })
call unite#filters#sorter_default#use(['sorter_rank'])
call unite#filters#matcher_default#use(['matcher_fuzzy'])
call unite#set_profile('files', 'context.smartcase', 1)
call unite#custom#source('line,outline', 'matchers', 'matcher_fuzzy')
nnoremap <leader>ur :<C-u>Unite -buffer-name=register register -auto-resize <cr>
nnoremap <leader>uy :<C-u>Unite -buffer-name=yank history/yank<cr>
nnoremap <leader>ub :<C-u>Unite -buffer-name=buffer buffer<cr>
nnoremap <leader>uf :<C-u>Unite -buffer-name=files -toggle -auto-resize file_rec/async<cr>
nnoremap <leader>ue :<C-u>Unite -buffer-name=files buffer file_mru bookmark file<cr>
nnoremap <leader>uo :<C-u>Unite -buffer-name=outline outline -auto-resize<cr>
nnoremap <leader>uh :<C-u>Unite -buffer-name=help help -auto-resize<cr>
nnoremap <leader>ut :<C-u>Unite -buffer-name=tag tag tag/file -auto-resize<cr>
if executable('ag')
	set grepprg=ag\ --nogroup\ --column\ --smart-case\ --nocolor\ --follow
	set grepformat=%f:%l:%C:%m
	let g:unite_source_grep_command='ag'
	let g:unite_source_grep_default_opts='--nocolor --nogroup --hidden'
	let g:unite_source_grep_recursive_opt=''
elseif executable('ack')
	set grepprg=ack\ --nogroup\ --column\ --smart-case\ --nocolor\ --follow\ $*
	set grepformat=%f:%l:%c:%m
	let g:unite_source_grep_command='ack'
	let g:unite_source_grep_default_opts='--no-heading --no-color -a'
	let g:unite_source_grep_recursive_opt=''
endif
autocmd FileType unite call s:unite_settings()
function! s:unite_settings()
	imap <buffer> <C-j> <Plug>(unite_select_next_line)
	imap <buffer> <C-k> <Plug>(unite_select_previous_line)
	imap <buffer> <esc> <Plug>(unite_exit)
	nmap <buffer> <esc> <Plug>(unite_exit)
	imap <silent><buffer><expr> <C-x> unite#do_action('split')
	imap <silent><buffer><expr> <C-v> unite#do_action('vsplit')
	imap <silent><buffer><expr> <C-t> unite#do_action('tabopen')
endfunction
"" }}}

"" {{{ syntax chechking
let g:syntastic_enable_signs = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_error_symbol = '✗'
let g:syntastic_style_error_symbol = '✠'
let g:syntastic_warning_symbol = '∆'
let g:syntastic_style_warning_symbol = '≈'
let g:syntastic_html_tidy_ignore_errors=[" proprietary attribute \"ng-"]
"" }}}

"" {{{ tmux integration
let g:tmuxify_custom_command = 'tmux split-window -d -l 10'
let g:tmuxify_run = {
	\ 'lilypond':   ' for file in %; do; lilypond $file; x-pdf "${file[@]/%ly/pdf}"; done',
	\ 'tex':        ' for file in %; do; texi2pdf $file; x-pdf "${file[@]/%tex/pdf}"; done',
	\ 'ruby':       ' ruby %',
	\ 'python':     ' python %',
	\ 'javascript': ' node %'
\}
"" }}}

"" {{{ gundo settings
nnoremap <F5> :GundoToggle<CR>
let g:gundo_right = 1
let g:gundo_width = 60
let g:gundo_preview_height = 40
"" }}}

"" {{{ searching
map /  <Plug>(incsearch-forward)
map ?  <Plug>(incsearch-backward)
map g/ <Plug>(incsearch-stay)
map n  <Plug>(incsearch-nohl-n)
map N  <Plug>(incsearch-nohl-N)
map *  <Plug>(incsearch-nohl-*)
map #  <Plug>(incsearch-nohl-#)
map g* <Plug>(incsearch-nohl-g*)
map g# <Plug>(incsearch-nohl-g#)
let g:incsearch#consistent_n_direction = 1
let g:incsearch#auto_nohlsearch = 1
let g:incsearch#magic = '\v'
"" }}}

"" {{{ fugitive shortcuts
nnoremap <leader>gs <Esc>:Gstatus<CR>
nnoremap <leader>gd <Esc>:Gdiff<CR>
nnoremap <leader>gc <Esc>:Gcommit<CR>
nnoremap <leader>gb <Esc>:Gblame<CR>
nnoremap <leader>gl <Esc>:Glog<CR>
nnoremap <leader>gp <Esc>:Git push<CR>
nnoremap <leader>gu <Esc>:Git pull<CR>
"" }}}

"" {{{ status line
let g:airline_enable_branch = '1'
let g:airline_theme = 'bubblegum'
let g:airline_detect_whitespace = 0
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#fnamemod = ':t'
"" }}}

"" {{{ misc plugins
nmap <Leader>a <Plug>(EasyAlign)
vmap <Leader>a <Plug>(EasyAlign)

map + <Plug>(expand_region_expand)
map _ <Plug>(expand_region_shrink)

let g:titlecase_map_keys = 0
nmap <leader>gt <Plug>Titlecase
vmap <leader>gt <Plug>Titlecase
nmap <leader>gT <Plug>TitlecaseLine
"" }}}

if has("gui_running")
	colorscheme slate
	set background=dark
	set gfn=Tewi\ 11
	set guioptions-=L
	set guioptions-=r
	set guioptions-=b
	set guioptions-=T
	set guioptions-=m
endif

autocmd! bufwritepost ~/.vimrc,~/dotfiles/vimrc source ~/.vimrc | AirlineRefresh
autocmd! bufwritepost ~/.tmux.conf,~/dotfiles/*.tmux.conf call system('tmux source-file ~/.tmux.conf; tmux display-message "Sourced .tmux.conf"')
autocmd FileType vim nnore <silent><buffer> K :<C-U>vert help <C-R><C-W><CR>
autocmd VimResized * :wincmd =

autocmd BufReadPost *
\	if line("'\"") > 0 && line("'\"") <= line("$") |
\		exe 'normal! g`"zvzz' |
\	endif


function! Dotfiles()
	cd ~/dotfiles
	edit zshrc
	vsplit bash_aliases
	wincmd h
	tabnew vimrc
	vert help quickref
	wincmd h
	tabnew local.tmux.conf
	vert diffsplit remote.tmux.conf
	wincmd h
	tabnew config/awesome/rc.lua
	tabfirst
endfunction
