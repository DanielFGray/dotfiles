set nocompatible
filetype off

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

Bundle 'gmarik/vundle'
Bundle 'tpope/vim-fugitive'
Bundle 'tpope/vim-surround'
Bundle 'tpope/vim-abolish'
Bundle 'mhinz/vim-startify'
Bundle 'Shougo/unite.vim'
Bundle 'mattn/zencoding-vim'
Bundle 'mhinz/vim-tmuxify'
if version >= 703
	Bundle 'Lokaltog/vim-powerline'
endif

syntax on
filetype plugin indent on

if version >= 703
	set colorcolumn=80
	set relativenumber
	set cursorcolumn cursorline
else
	set number
endif
set laststatus=2
set hlsearch
set backspace=indent,eol,start
set nowrap
set showmatch
set equalalways
set wildmenu
set autoindent smartindent
set smartindent smarttab
set tabstop=4 softtabstop=4 shiftwidth=4
set foldmethod=marker
set ruler
set rulerformat=%30(%=\:b%n%y%m%r%w\ %l,%c%V\ %P%)
set hidden
set list
set fillchars+=vert:â”‚
set listchars=tab:\|\ ,eol:★,trail:◥,extends:>,precedes:<,nbsp:.
set showcmd
set mouse=a
set nolazyredraw
set autoread
set t_Co=256
set shortmess+=I

set ofu=syntaxcomplete#Complete
"set tags+=~/.vim/gtk+.tags

colorscheme smyck
set background=dark

let g:Powerline_symbols = 'compatible'

let g:tmuxify_pane_split = '-v'
let g:tmuxify_pane_size = '10'
let g:tmuxify_run = { 'sh': 'zsh %', 'go': 'go build %' }

let g:user_zen_expandabbr_key = '<c-e>'
let g:use_zen_complete_tag = 1

function! RangerChooser()
	silent !ranger --choosefile=/tmp/chosenfile `[ -z '%' ] && echo -n . || dirname %`
	if filereadable('/tmp/chosenfile')
		exec 'edit ' . system('cat /tmp/chosenfile')
		call system('rm /tmp/chosenfile')
	endif
	redraw!
endfunction
map ,r :call RangerChooser()<CR>


if version >= 703
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
endif

nnoremap <A-a> <C-a>
nnoremap <A-x> <C-x:

autocmd! bufwritepost ~/.vimrc source ~/.vimrc
ca w!! w !sudo tee >/dev/null "%"

" {{{ placebos
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
"hi ColorColumn  ctermbg=8

hi link Number Constant
hi! link StatusLine VertSplit
hi! link StatusLineNC VertSplit
hi! link Question Special
hi! link MoreMsg Special
hi! link Folded Normal

hi link Operator Delimiter
hi link Function Identifier
hi link PmenuSel PmenuThumb
hi link Error ErrorMsg
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
" }}}
