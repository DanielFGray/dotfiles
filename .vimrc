set nocompatible

call pathogen#infect()
let g:Powerline_symbols = 'compatible'
set laststatus=2   " Always show the statusline

set scrolloff=3
set number
set hlsearch
set backspace=indent,eol,start
set nowrap
set showmatch
set wildmenu
set cursorline
set autoindent
set smartindent
set smarttab
set tabstop=4
set shiftwidth=4
set expandtab
set foldmethod=marker
set ruler
"set rulerformat=%30(%=\:b%n%y%m%r%w\ %l,%c%V\ %P%)
set showcmd
set ofu=syntaxcomplete#Complete
set mouse=a
set nolazyredraw
set autoread
set t_Co=256

syntax on
filetype plugin indent on

":colorscheme slate
set background=dark
set gfn=Ubuntu\ Mono\ 8
set guioptions-=l
set guioptions-=r
set guioptions-=b
set guioptions-=T

noremap <Up> <nop>
noremap <Down> <nop>
noremap <Left> <nop>
noremap <Right> <nop>

autocmd! bufwritepost ~/.vimrc source ~/.vimrc
ca w!! w !sudo tee >/dev/null "%"
"command CDC cd %:p:h

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
