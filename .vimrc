set nocompatible

call pathogen#infect()
let g:Powerline_symbols = 'compatible'
set laststatus=2   " Always show the statusline

set scrolloff=50
set hlsearch
set backspace=indent,eol,start
set nowrap
set showmatch
set equalalways
set wildmenu
set cursorcolumn cursorline
set autoindent smartindent
set smartindent smarttab
set tabstop=4 softtabstop=4 shiftwidth=4
set foldmethod=marker
set ruler
set rulerformat=%30(%=\:b%n%y%m%r%w\ %l,%c%V\ %P%)
set hidden
set list
set fillchars+=vert:│
set listchars=tab:\|\ ,eol:★,trail:◥,extends:>,precedes:<,nbsp:.
set colorcolumn=80
set showcmd
set mouse=a
set nolazyredraw
set relativenumber
set autoread
set t_Co=256
set shortmess+=I

syntax on
filetype plugin indent on

set ofu=syntaxcomplete#Complete
"set tags+=~/.vim/gtk+.tags

colorscheme smyck
set background=dark
if has("gui_running")
	set gfn=Ubuntu\ Mono\ for\ Powerline\ 8
	set guioptions-=l
	set guioptions-=r
	set guioptions-=b
	set guioptions-=T
	set guioptions-=m
	"let g:Powerline_symbols = 'fancy'
endif

function! RangerChooser()
	silent !ranger --choosefile=/tmp/chosenfile `[ -z '%' ] && echo -n . || dirname %`
	if filereadable('/tmp/chosenfile')
		exec 'edit ' . system('cat /tmp/chosenfile')
		call system('rm /tmp/chosenfile')
	endif
	redraw!
endfunction
map ,r :call RangerChooser()<CR>

"function! SuperCleverTab()
"	if strpart( getline('.'), 0, col('.')-1 ) =~ '^\s*$'
"		return "\<Tab>"
"	else
"		if &omnifunc != ''
"			return "\<C-X>\<C-O>"
"		elseif &dictionary != ''
"			return “\<C-K>”
"		else
"			return "\<C-N>"
"		endif
"	endif
"endfunction
"inoremap <Tab> <C-R>=SuperCleverTab()<cr>

nnoremap <A-a> <C-a>
nnoremap <A-x> <C-x>

nnoremap <F5> :GundoToggle<CR>

noremap <leader>o <Esc>:CommandT<CR>
noremap <leader>O <Esc>:CommandTFlush<CR>
noremap <leader>m <Esc>:CommandTBuffer<CR>

if exists("&undodir")
	set undodir=~/.vim/undo//
endif
if exists("&backupdir")
	set backupdir=~/.vim/backups//
endif
if exists("&directory")
	set directory=~/.vim/swaps//
endif
set undofile
set undolevels=1000
set undoreload=10000

autocmd! bufwritepost ~/.vimrc source ~/.vimrc
ca w!! w !sudo tee >/dev/null "%"

hi Comment      ctermfg=12
hi Constant     ctermfg=6
hi Identifier   ctermfg=4
hi Statement    ctermfg=2
hi PreProc      ctermfg=1
hi Type         ctermfg=3
hi Special      ctermfg=5
hi Underlined   ctermfg=7
hi Ignore       ctermfg=9
hi Error        ctermfg=11
hi Todo         ctermfg=1
hi ColorColumn  ctermbg=8

hi link Number Constant
hi! link StatusLine VertSplit
hi! link StatusLineNC VertSplit
hi! link Question Special
hi! link MoreMsg Special
hi! link Folded Normal

hi link Operator Delimiter
hi link Function Identifier
hi link PmenuSel PmenuThumb
hi link Error	ErrorMsg
hi link Conditional Keyword
hi link Character String
hi link Boolean Constant
hi link Float Number
hi link Repeat Statement
hi link Label Statement
hi link Exception Statement
hi link Include PreProc
hi link Define PreProc
hi link Macro PreProc
hi link PreCondit PreProc
hi link StorageClass Type
hi link Structure Type
hi link Typedef Type
hi link Tag Special
hi link SpecialChar Special
hi link SpecialComment Special
hi link Debug Special

hi clear SpellBad
hi SpellBad ctermfg=red term=underline cterm=underline
hi clear SpellCap
hi SpellCap term=underline cterm=underline
hi clear SpellRare
hi SpellRare term=underline cterm=underline
hi clear SpellLocal
hi SpellLocal term=underline cterm=underline
