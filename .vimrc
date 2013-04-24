set nocompatible

call pathogen#infect()
let g:Powerline_symbols = 'compatible'

set scrolloff=50
set hlsearch
set backspace=indent,eol,start
set nowrap
set showmatch
set equalalways
set list
set fillchars+=vert:│
set listchars=tab:\|\ ,eol:★,trail:◥,extends:>,precedes:<,nbsp:.
set hidden
set wildmenu
set cursorcolumn cursorline
set autoindent copyindent
set smartindent smarttab
set tabstop=4 softtabstop=4 shiftwidth=4
set foldmethod=marker
set laststatus=2
set ruler
set rulerformat=%30(%=\:b%n%y%m%r%w\ %l,%c%V\ %P%)
set showcmd
set mouse=a
set nolazyredraw
set relativenumber
set autoread
set t_Co=256
set shortmess+=I
set colorcolumn=80

syntax on
filetype plugin indent on

set ofu=syntaxcomplete#Complete
"set tags+=~/.vim/gtk+.tags

colorscheme smyck
set background=dark
if has("gui_running")
	set gfn=Monaco\ 7
	"set gfn=Monaco\ for\ Powerline\ 8
	set guioptions-=l
	set guioptions-=r
	set guioptions-=b
	set guioptions-=T
	set guioptions-=m
	"let g:Powerline_symbols = 'fancy'
endif

" let g:expand_region_text_objects = {
" 	'iw'  :0,
" 	'iW'  :1,
" 	'i"'  :0,
" 	'i''' :0,
" 	'i]'  :1, " Support nesting of square brackets
" 	'ib'  :1, " Support nesting of parentheses
" 	'iB'  :1, " Support nesting of braces
" 	'il'  :0, " Not included in Vim by default. See https://github.com/kana/vim-textobj-line
" 	'ip'  :0,
" 	'ie'  :0  " Not included in Vim by default. See https://github.com/kana/vim-textobj-entire
" }

function! RangerChooser()
	silent !ranger --choosefile=/tmp/chosenfile `[ -z '%' ] && echo -n . || dirname %`
	if filereadable('/tmp/chosenfile')
		exec 'edit ' . system('cat /tmp/chosenfile')
		call system('rm /tmp/chosenfile')
	endif
	redraw!
endfunction
map ,r :call RangerChooser()<CR>

function! SuperCleverTab()
	if strpart( getline('.'), 0, col('.')-1 ) =~ '^\s*$'
		return "\<Tab>"
	else
		if &omnifunc != ''
			return "\<C-X>\<C-O>"
		elseif &dictionary != ''
			return “\<C-K>”
		else
			return "\<C-N>"
		endif
	endif
endfunction
inoremap <Tab> <C-R>=SuperCleverTab()<cr>

nnoremap <C-a> <A-a>
nnoremap <C-x> <A-x>

inoremap <Up> <Esc><Up><Right>
inoremap <Down> <Esc><Down><Right>
inoremap <Left> <Esc><Left><Right>
inoremap <Right> <Esc><Right><Right>

autocmd! bufwritepost ~/.vimrc source ~/.vimrc

ca w!! w !sudo tee >/dev/null "%"

if exists("&undodir")
	set undodir=~/.vim/undo//
endif
set undofile
set undolevels=1000
set undoreload=10000
set nobackup
set noswapfile

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
