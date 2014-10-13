"" {{{ bundles
set runtimepath+=~/.vim/bundle/neobundle.vim/
call neobundle#begin(expand('~/.vim/bundle/'))
NeoBundleFetch 'Shougo/neobundle.vim'
NeoBundle 'Shougo/vimproc',                             {'build': {'unix': 'make -f make_unix.mak'}}
NeoBundle 'Shougo/unite.vim',                           {'name': 'unite.vim', 'depends': 'vimproc'}
NeoBundleLazy 'thinca/vim-unite-history',               {'depends': 'unite.vim', 'autoload': {'unite_sources': 'history/command'}}
NeoBundleLazy 'Shougo/unite-help',                      {'depends': 'unite.vim', 'autoload': {'unite_sources': 'help'}}
NeoBundleLazy 'Shougo/unite-outline',                   {'autoload': {'unite_sources': 'outline'}}
NeoBundleLazy 'Shougo/unite-session',                   {'autoload': {'unite_sources': 'session', 'commands': ['UniteSessionSave', 'UniteSessionLoad']}}
NeoBundleLazy 'Shougo/neomru.vim',                      {'autoload': {'unite_sources': 'file_mru'}}
NeoBundleLazy 'tsukkee/unite-tag',                      {'autoload': {'unite_sources': ['tag', 'tag/file']}}
NeoBundleFetch 'Shougo/neocomplcache.vim'

NeoBundle 'Shougo/context_filetype.vim'
NeoBundle 'Shougo/echodoc'
NeoBundle 'Shougo/neocomplete.vim'
NeoBundle 'Shougo/neosnippet'
NeoBundle 'Shougo/neosnippet-snippets'
NeoBundle 'Shougo/vimfiler'
NeoBundle 'osyo-manga/unite-filetype'

NeoBundle 'scrooloose/syntastic'
NeoBundle 'terryma/vim-expand-region'
NeoBundle 'wellle/targets.vim'
NeoBundle 'junegunn/vim-easy-align'
NeoBundle 'tpope/vim-fugitive'
NeoBundle 'tpope/vim-surround'
NeoBundle 'tpope/vim-abolish'
NeoBundle 'tpope/vim-unimpaired'
NeoBundle 'tpope/vim-repeat'
NeoBundle 'tpope/vim-vinegar'
NeoBundle 'mhinz/vim-startify'
NeoBundle 'mhinz/vim-tmuxify'
NeoBundle 'bling/vim-airline'
NeoBundle 'sjl/gundo.vim'
NeoBundle 'zhaocai/GoldenView.Vim'
NeoBundle 'noahfrederick/vim-noctu'
NeoBundle 'Shougo/vimshell.vim'
NeoBundle 'jaxbot/browserlink.vim',                     {'autoload': {'filetypes': ['html', 'javascript', 'css']}}
NeoBundle 'mattn/gist-vim',                             {'depends': 'mattn/webapi-vim'}

NeoBundleLazy 'mattn/emmet-vim',                        {'autoload': {'filetypes': ['html', 'xml', 'xsl', 'xslt', 'xsd', 'css', 'sass', 'scss', 'less', 'mustache']}}
NeoBundleLazy 'tmhedberg/matchit',                      {'autoload': {'filetypes': ['html', 'xml', 'xsl', 'xslt', 'xsd', 'css', 'sass', 'scss', 'less', 'mustache']}}
NeoBundleLazy 'Raimondi/delimitMate',                   {'autoload': {'filetypes': ['html', 'xml']}}
NeoBundleLazy 'gregsexton/MatchTag',                    {'autoload': {'filetypes': ['html', 'xml']}}
NeoBundleLazy 'othree/html5.vim',                       {'autoload': {'filetypes': ['html']}}
NeoBundleLazy 'groenewege/vim-less',                    {'autoload': {'filetypes': ['less']}}
NeoBundleLazy 'hail2u/vim-css3-syntax',                 {'autoload': {'filetypes': ['css', 'scss', 'sass']}}
NeoBundleLazy 'digitaltoad/vim-jade',                   {'autoload': {'filetypes': ['jade']}}

NeoBundleLazy 'moll/vim-node',                          {'autoload': {'filetypes': ['javascript']}}
NeoBundleLazy 'jelera/vim-javascript-syntax',           {'autoload': {'filetypes': ['javascript']}}
NeoBundleLazy 'othree/javascript-libraries-syntax.vim', {'autoload': {'filetypes': ['javascript']}}
NeoBundleLazy 'burnettk/vim-angular',                   {'autoload': {'filetypes': ['javascript']}}
NeoBundleLazy 'marijnh/tern_for_vim',                   {'autoload': {'filetypes': ['javascript']}, 'build': {'unix': 'npm install'}}
NeoBundleLazy 'pangloss/vim-javascript',                {'autoload': {'filetypes': ['javascript']}}
NeoBundleLazy 'sheerun/vim-polyglot',                   {'autoload': {'filetypes': ['javascript']}}
NeoBundleLazy 'walm/jshint.vim',                        {'autoload': {'filetypes': ['javascript']}}
NeoBundleLazy 'kchmck/vim-coffee-script',               {'autoload': {'filetypes': ['coffee']}}
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
colorscheme noctu

noremap ; :
noremap : ;
nnoremap Y y$
nnoremap / /\v
vnoremap / /\v
nnoremap n nzzzv
nnoremap N Nzzzv
cnoremap s/ sm/
cnoremap vh vert h 

ca w!! w !sudo tee >/dev/null "%"
set pastetoggle=<F6>
nmap <Leader>a <Plug>(EasyAlign)
vmap <Leader>a <Plug>(EasyAlign)
map + <Plug>(expand_region_expand)
map _ <Plug>(expand_region_shrink)

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
set tags+=~/.vim/tags/gtk+.tags
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
"" let g:neocomplete#sources#dictionary#dictionaries = {  'default' : '' }
"" let g:neocomplete#data_directory=s:get_cache_dir('neocomplete')
"" if !exists('g:neocomplete#sources#omni#input_patterns')
""   let g:neocomplete#sources#omni#input_patterns = {}
"" endif
"" if !exists('g:neocomplete#keyword_patterns')
""     let g:neocomplete#keyword_patterns = {}
"" endif
"" let g:neocomplete#keyword_patterns['default'] = '\h\w*'
inoremap <expr><C-g>     neocomplete#undo_completion()
inoremap <expr><C-l>     neocomplete#complete_common_string()
inoremap <expr><BS>      neocomplete#smart_close_popup()."\<C-h>"
inoremap <expr><TAB>     pumvisible() ? "\<C-n>" : "\<TAB>"
"" "}}}

"" {{{ snippets
let g:neosnippet#snippets_directory='~/.vim/bundle/vim-snippets/snippets,~/.vim/snippets'
let g:neosnippet#enable_snipmate_compatibility=1
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
call unite#custom#profile('default', 'context', { 'start_insert': 1 })
call unite#filters#sorter_default#use(['sorter_rank'])
call unite#filters#matcher_default#use(['matcher_fuzzy'])
call unite#set_profile('files', 'context.smartcase', 1)
call unite#custom#source('line,outline', 'matchers', 'matcher_fuzzy')
nnoremap <leader>ur :<C-u>Unite register<cr>
nnoremap <leader>uy :<C-u>Unite -buffer-name=yank    history/yank<cr>
nnoremap <leader>ub :<C-u>Unite -buffer-name=buffer  buffer<cr>
nnoremap <leader>uf :<C-u>Unite -toggle -auto-resize -buffer-name=files file_rec/async<cr>
nnoremap <leader>ue :<C-u>UniteWithBufferDir -buffer-name=files buffer file_mru bookmark file<cr>
nnoremap <leader>uo :<C-u>Unite -auto-resize -buffer-name=outline outline<cr>
nnoremap <leader>uh :<C-u>Unite -auto-resize -buffer-name=help help<cr>
nnoremap <leader>ut :<C-u>Unite -auto-resize -buffer-name=tag tag tag/file<cr>
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
	\ 'ruby':       ' ruby %',
	\ 'python':     ' python %',
	\ 'javascript': ' nodejs %'
\}
"" }}}

" {{{ gundo settings
nnoremap <F5> :GundoToggle<CR>
let g:gundo_right = 1
let g:gundo_width = 60
let g:gundo_preview_height = 40
"" }}}

" {{{ fugitive shortcuts
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

if has("gui_running")
	set background=dark
	colorscheme desert
	set gfn=Tewi\ 11
	set guioptions-=L
	set guioptions-=r
	set guioptions-=b
	set guioptions-=T
	set guioptions-=m
endif

augroup Tmux
	au!
	autocmd VimEnter,BufNewFile,BufReadPost * call system('tmux rename-window "vim - ' . split(substitute(getcwd(), $HOME, '~', ''), '/')[-1] . '"')
	autocmd VimLeave * call system('tmux rename-window ' . split(substitute(getcwd(), $HOME, '~', ''), '/')[-1])
augroup END

autocmd! bufwritepost ~/.vimrc,~/dotfiles/.vimrc source ~/.vimrc | AirlineRefresh
autocmd FileType vim setlocal keywordprg=:help
au VimResized * :wincmd =

function! Dotfiles()
	cd ~/dotfiles
	edit .zshrc
	vsplit .bash_aliases
	tabnew .vimrc
	vert help quickref
	tabnew local.tmux.conf
	vert diffsplit remote.tmux.conf
	tabnew .config/awesome/rc.lua
endfunction
