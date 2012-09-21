set nocompatible
filetype off
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()
Bundle 'gmarik/vundle'

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
set tabstop=8
set shiftwidth=8
set expandtab
set foldmethod=marker
set ruler
set rulerformat=%30(%=\:b%n%y%m%r%w\ %l,%c%V\ %P%)
set showcmd
set ofu=syntaxcomplete#Complete
set mouse=a
set nolazyredraw
syntax on
filetype plugin indent on

colorscheme slate
set background=dark
set gfn=Ubuntu\ Mono\ 8
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

" Ruby
hi link rubyClass Keyword
hi link rubyModule Keyword
hi link rubyKeyword Keyword
hi link rubyOperator Operator
hi link rubyIdentifier Identifier
hi link rubyInstanceVariable Identifier
hi link rubyGlobalVariable Identifier
hi link rubyClassVariable Identifier
hi link rubyConstant Type

" HTML/XML
hi link xmlTag HTML
hi link xmlTagName HTML
hi link xmlEndTag HTML
hi link htmlTag HTML
hi link htmlTagName HTML
hi link htmlSpecialTagName HTML
hi link htmlEndTag HTML
hi link HTML NonText

" JavaScript
hi link javaScriptNumber Number

" Objc
hi link objcDirective Type
hi objcMethodName ctermfg=darkyellow

" CSS
hi link cssBraces Normal
hi link cssTagName NonText
hi link StorageClass Special
hi link cssClassName Special
hi link cssIdentifier Identifier
hi link cssColor Type
hi link cssValueInteger Type
hi link cssValueNumber Type
hi link cssValueLength Type
hi cssPseudoClassId ctermfg=darkyellow

hi clear SpellBad
hi SpellBad ctermfg=red term=underline cterm=underline
hi clear SpellCap
hi SpellCap term=underline cterm=underline
hi clear SpellRare
hi SpellRare term=underline cterm=underline
hi clear SpellLocal
hi SpellLocal term=underline cterm=underline
