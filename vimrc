scriptencoding utf8
filetype plugin indent on
let g:mapleader = "\<Space>"

" you can press K on most plugin names and settings for more info
" navigate folds with za to toggle, zA to toggle recursively, zM to close all
" :h fold

" {{{ plugins
let s:configdir = has('nvim') ? '~/.vim' : '~/.config/nvim'
call plug#begin(s:configdir . '/bundle')
" using full urls so the terminal can make them clickable
" {{{ utilities
Plug 'https://github.com/tpope/vim-sensible'               " some sane defaults
Plug 'https://github.com/tpope/vim-unimpaired'             " lots of keybinds `[e ]b yox`
Plug 'https://github.com/liuchengxu/vim-which-key' " {{{   " visual keybind navigator
  nnoremap <silent> <leader> :<c-u>WhichKey '<Space>'<CR>
  nnoremap <silent> g        :<c-u>WhichKey 'g'<CR>
  nnoremap <silent> [        :<c-u>WhichKey '['<CR>
  nnoremap <silent> ]        :<c-u>WhichKey ']'<CR>
  let g:which_key_hspace = 3
  let g:which_key_position = 'botleft'
  let g:which_key_use_floating_win = 0
" }}}
Plug 'https://github.com/mbbill/undotree' " {{{            " visual undo tree
  let g:undotree_WindowLayout = 4
  let g:undotree_SetFocusWhenToggle = 1
  let g:undotree_SplitWidth = 60
  nnoremap <silent> <leader>u :<C-u>UndotreeToggle<CR>
  function! g:Undotree_CustomMap() abort
    nnoremap <buffer> k <plug>UndotreeGoNextState
    nnoremap <buffer> j <plug>UndotreeGoPreviousState
    nnoremap <buffer> <Esc> <plug>UndotreeClose
  endfunc
" }}}
Plug 'https://github.com/chilicuil/vim-sprunge' " {{{      " quick paste to sprunge
  nnoremap <leader>pa <Plug>Sprunge
  xnoremap <leader>pa <Plug>Sprunge
  " let g:sprunge_cmd = 'curl -s -n -F "f:1=<-" http://ix.io'
" }}}
Plug 'https://github.com/kyazdani42/nvim-tree.lua'
Plug 'https://github.com/vim-utils/vim-husk'               " readline cmaps
Plug 'https://github.com/thinca/vim-qfreplace'             " editable quickfix window
Plug 'https://github.com/jiangmiao/auto-pairs'             " auto-close quotes/brackets
Plug 'https://github.com/tpope/vim-endwise'                " auto-closing block statements
" }}}
" {{{ operators
Plug 'https://github.com/tpope/vim-surround'               " manage surrounding pairs `ds.. cs.. ys..`
Plug 'https://github.com/tpope/vim-commentary'             " toggle comments `gcc`
Plug 'https://github.com/tommcdo/vim-exchange'             " swap selections `X..`
Plug 'https://github.com/AndrewRadev/splitjoin.vim'        " smarter `gJ` joins and split with gS
Plug 'https://github.com/tpope/vim-repeat'                 " repeats `.` for plugins
Plug 'https://github.com/junegunn/vim-easy-align' " {{{    " automatic visual alignments
  xmap <leader>al <Plug>(EasyAlign)
  nmap <leader>al <Plug>(EasyAlign)
" }}}
Plug 'https://github.com/dahu/Insertlessly' " {{{          " insert newline with enter
  let g:insertlessly_open_newlines = 0
  let g:insertlessly_insert_spaces = 0
  let g:insertlessly_backspace_past_bol = 0
  let g:insertlessly_cleanup_trailing_ws = 0
  let g:insertlessly_cleanup_all_ws = 0
  let g:insertlessly_adjust_cursor = 1
" }}}
Plug 'https://github.com/christoomey/vim-titlecase' " {{{  " Title Case mapping 
  let g:titlecase_map_keys = 0
  nmap <leader>gt <Plug>Titlecase
  vmap <leader>gt <Plug>Titlecase
  nmap <leader>gT <Plug>TitlecaseLine
" }}}
Plug 'https://github.com/tpope/vim-speeddating'            " ctrl-a/x work on more formats
" }}}
" {{{ motions
Plug 'https://github.com/wellle/targets.vim'               " extended motions `vin)`
Plug 'https://github.com/justinmk/vim-sneak' " {{{         " two char sneak `s.. S..` and linewise `fFtT;,`
  let g:sneak#prompt = ''
  map <silent> f <Plug>Sneak_f
  map <silent> F <Plug>Sneak_F
  map <silent> t <Plug>Sneak_t
  map <silent> T <Plug>Sneak_T
  map <silent> ; <Plug>SneakNext
  map <silent> , <Plug>SneakPrevious
" }}}
Plug 'https://github.com/haya14busa/vim-asterisk' " {{{    " improved * search
  map *  <Plug>(asterisk-z*)
  map #  <Plug>(asterisk-z#)
  map g* <Plug>(asterisk-gz*)
  map g# <Plug>(asterisk-gz#)
" }}}
Plug 'https://github.com/kana/vim-textobj-user' " {{{      " custom textobj engine
" more textobj https://github.com/kana/vim-textobj-user/wiki
" }}}
Plug 'https://github.com/glts/vim-textobj-comment'         " select comments `vac`
Plug 'https://github.com/kana/vim-textobj-indent'          " indent textobj  `vii`
Plug 'https://github.com/adelarsq/vim-matchit'             " extended % matching
" }}}
" {{{ commands
Plug 'https://github.com/tpope/vim-abolish'                " extended subsititions and replacements `:S :Ab`
Plug 'https://github.com/tpope/vim-eunuch'                 " simple commands for common linux tasks
Plug 'https://github.com/haya14busa/is.vim'                " linewise visual search highlight
Plug 'https://github.com/markonm/traces.vim'               " visual substitution highlight
Plug 'https://github.com/junegunn/fzf'                     " fzf integration `:FZF`
Plug 'https://github.com/vijaymarupudi/nvim-fzf'
Plug 'https://github.com/junegunn/fzf.vim' " {{{           " fzf commands `:Files :Maps`
  nnoremap <silent> <leader><leader> :<C-u>Maps<CR>
  nnoremap <silent> <leader>f :<C-u>Files<CR>
  nnoremap <silent> <leader>; :<C-u>Commands<CR>
  if executable('rg')
    nnoremap <leader>gr :<C-u>Rg<Space>
  elseif executable('ag')
    nnoremap <leader>gr :<C-u>Ag<Space>
  endif
" }}}
" }}}
" {{{ appearance
Plug 'https://github.com/kyazdani42/nvim-web-devicons'     " for file icons
Plug 'https://github.com/itchyny/lightline.vim' " {{{
  Plug 'https://github.com/josa42/vim-lightline-coc'
  Plug 'https://github.com/mengelbrecht/lightline-bufferline'
  Plug 'https://github.com/ryanoasis/vim-devicons'
  let g:lightline#bufferline#show_number  = 0
  let g:lightline#bufferline#shorten_path = 1
  let g:lightline#bufferline#unnamed      = '[No Name]'
  let g:lightline#bufferline#enable_devicons = 1
	let g:lightline = {
  \   'separator': { 'left': '', 'right': '' },
  \   'subseparator': { 'left': '', 'right': '' },
  \   'tabline': {
  \     'left': [ ['buffers'] ],
  \     'right': [ ['close'] ]
  \   },
  \ }
  let g:lightline.component = {
  \   'mode': '%{lightline#mode()}',
  \   'absolutepath': '%F',
  \   'relativepath': '%f',
  \   'filename': '%t',
  \   'modified': '%M',
  \   'bufnum': '%n',
  \   'paste': '%{&paste?"PASTE":""}',
  \   'readonly': '%R',
  \   'charvalue': '%b',
  \   'charvaluehex': '%B',
  \   'fileencoding': '%{&fenc!=#""?&fenc:&enc}',
  \   'fileformat': '%{&ff}',
  \   'filetype': '%{&ft!=#""?&ft:"no ft"}',
  \   'percent': '%3p%%',
  \   'percentwin': '%P',
  \   'spell': '%{&spell?&spelllang:""}',
  \   'lineinfo': '%3l:%-2c',
  \   'line': '%l',
  \   'column': '%c',
  \   'close': '%999X X ',
  \   'winnr': '%{winnr()}',
  \ }
  let g:lightline.mode_map = {
  \   'n' : 'N',
  \   'i' : 'I',
  \   'R' : 'R',
  \   'v' : 'v',
  \   'V' : 'V',
  \   "\<C-v>": 'V',
  \   'c' : 'C',
  \   's' : 's',
  \   'S' : 'S',
  \   "\<C-s>": 'S',
  \   't': 'T',
  \ }

  let g:lightline.component_raw = {'buffers': 1}
  let g:lightline.component_expand = {
  \   'linter_warnings': 'lightline#coc#warnings',
  \   'linter_errors': 'lightline#coc#errors',
  \   'linter_info': 'lightline#coc#info',
  \   'linter_hints': 'lightline#coc#hints',
  \   'linter_ok': 'lightline#coc#ok',
  \   'coc_status': 'lightline#coc#status',
  \   'gitbranch': 'LightlineFugitive',
  \   'buffers': 'lightline#bufferline#buffers'
  \ }

	function! LightlineFugitive()
		if exists('*FugitiveHead')
			return FugitiveHead()
		endif
		return ''
	endfunction

  " Set color to the components:
  let g:lightline.component_type = {
  \   'linter_warnings': 'warning',
  \   'linter_errors': 'error',
  \   'linter_info': 'info',
  \   'linter_hints': 'hints',
  \   'linter_ok': 'left',
  \ }

  " Add the components to the lightline:
  let g:lightline.active = {
  \   'left': [
  \     [ 'mode', 'paste' ],
  \     [ 'gitbranch', 'readonly', 'filename' ]
  \   ],
  \   'right': [
  \     [ 'percent' ],
  \     [ 'filetype' ],
  \     [ 'coc_info', 'coc_hints', 'coc_errors', 'coc_warnings', 'coc_ok', 'coc_status' ]
  \   ]
  \ }
" }}}
Plug 'https://github.com/mhinz/vim-startify' " {{{         " fancy start screen
  let g:startify_change_to_vcs_root = 1

  " function! s:filter_header(str) abort
  "   return map(split(system('figlet -f future "'. a:str .'"'), '\n'), '"   ". v:val') + [ '', '' ]
  " endfunction

  if has('nvim')
    " let g:startify_custom_header = s:filter_header('NeoVim')
    let g:startify_custom_header =
    \ [ '   ┏┓╻┏━╸┏━┓╻ ╻╻┏┳┓'
    \ , '   ┃┗┫┣╸ ┃ ┃┃┏┛┃┃┃┃'
    \ , '   ╹ ╹┗━╸┗━┛┗┛ ╹╹ ╹'
    \ ]
  else
    " let g:startify_custom_header = s:filter_header('Vim')
    let g:startify_custom_header =
    \ [ '   ╻ ╻╻┏┳┓'
    \ , '   ┃┏┛┃┃┃┃'
    \ , '   ┗┛ ╹╹ ╹'
    \ ]
  endif
" }}}
Plug 'https://github.com/machakann/vim-highlightedyank'    " highlight yanked selection
Plug 'https://github.com/noahfrederick/vim-noctu'          " a simple terminal based theme
Plug 'https://github.com/flazz/vim-colorschemes'           " color scheme bundle
Plug 'https://github.com/danielfgray/distractionfree.vim'  " {{{ easy toggling visual features
function! s:distractions_off()
  set showmode showcmd
  IndentBlanklineDisable
endfunction
function! s:distractions_on()
  set noshowmode noshowcmd
  IndentBlanklineEnable
endfunction
autocmd! User DistractionsOn nested call <SID>distractions_on()
autocmd! User DistractionsOff nested call <SID>distractions_off()
" }}}
Plug 'https://github.com/junegunn/goyo.vim'
Plug 'https://github.com/junegunn/limelight.vim'
" }}}
" {{{ git
Plug 'https://github.com/tpope/vim-fugitive' " {{{         " stage and commit with git
  nnoremap <leader>gt :<C-u>Gstatus<CR>
  nnoremap <leader>gd :<C-u>Gdiff<CR>
  nnoremap <leader>gc :<C-u>Gcommit<CR>
  nnoremap <leader>gb :<C-u>Gblame<CR>
  nnoremap <leader>gP :<C-u>Git push<CR>
" }}}
Plug 'https://github.com/airblade/vim-gitgutter' " {{{     " line indicators for git
  " alternatively see https://github.com/mhinz/vim-signify
  let g:gitgutter_map_keys = 0
  nnoremap <silent> [p :<C-u>GitGutterPrevHunk<CR>zMzvzz
  nnoremap <silent> ]p :<C-u>GitGutterNextHunk<CR>zMzvzz
  nnoremap <silent> <leader>gs :<C-u>GitGutterStageHunk<CR>
  nnoremap <silent> <leader>gu :<C-u>GitGutterUndoHunk<CR>
  nnoremap <silent> <leader>gp :<C-u>GitGutterPreviewHunk <CR>
" }}}
" }}}
" {{{ language-support
Plug 'https://github.com/mattn/emmet-vim' " {{{            " shorthand for html expansions
  \, { 'for': [ 'html', 'javascript.jsx', 'typescriptreact' ] }
  let g:user_emmet_settings = {
  \   'javascript.jsx' : {
  \       'extends' : 'jsx',
  \   },
  \ }
  " }}}
Plug 'https://github.com/sheerun/vim-polyglot'             " language highlighting/indent bundle
Plug 'https://github.com/lifepillar/pgsql.vim' " {{{       " better postgres highlighting
let g:sql_type_default = 'pgsql'
" }}}
Plug 'https://github.com/mhinz/vim-tmuxify' " {{{          " tmux integration
  let g:tmuxify_map_prefix = '<leader>tm'
  let g:tmuxify_custom_command = 'tmux splitw -dv -p25'
  let g:tmuxify_global_maps = 1
  let g:tmuxify_run = {
  \ 'lilypond':   ' f="%"; lilypond "$f" && x-pdf "${f/%ly/pdf}"; unset f',
  \ 'tex':        ' f="%"; texi2pdf "$f" && x-pdf "${f/%tex/pdf}"; unset f',
  \ 'ruby':       ' ruby %',
  \ 'python':     ' python %',
  \ 'javascript': ' node %',
  \ }
" }}}
Plug 'https://github.com/editorconfig/editorconfig-vim'

" }}}
call plug#end()
" }}}
" {{{ general settings
set mouse=nv                                               " mouse on for normal,visual mode (but not insert while typing)
set hidden                                                 " switch buffers without saving
set backspace=indent,eol,start                             " backspace over everything
set foldmethod=expr " foldopen-=block
set foldlevelstart=999                                     " open all folds by default
set foldtext=MyFoldText()                                  " custom fold marker
set hlsearch incsearch                                     " visual searching
set equalalways splitright                                 " split defaults
set showcmd                                                " visual operator pending
set signcolumn=yes                                         " always keep the sign column open
set number         " toggle with yon                       " show current line number (0 with rnu)
set relativenumber " toggle with yor                       " line numbers relative to current position
set nowrap         " toggle with yow                       " disable linewrap
set linebreak                                              " break at word boundaries when wrap enabled
set colorcolumn=80                                         " highlight 80th column
set noshowmode                                             " hide mode indicator
set confirm                                                " y/n save prompt on quit
set ttimeoutlen=10                                         " short esc wait duration
set modeline
set list listchars=tab:\|\ ,trail:★                        " visible tab chars and trailing spaces
set listchars+=extends:»,precedes:«                        " custom line wrap chars
" set listchars+=eol:¬,space:🞄                               " visible space and eol chars (very noisy)
set undofile undoreload=10000 undolevels=1000              " store 10kb of 1000 levels of undofile
set undodir=~/.vim/undo//                                  " undofiles in config dir
set backupdir=~/.vim/backups//                             " backups too
set directory=~/.vim/swaps//                               " the trailing slashes are important
set updatetime=300                                         " debounce swap file writing for 1000ms
set showtabline=2                                          " always show tabline
set timeoutlen=500                                         " duration of ..

if executable("rg") " {{{                                  " use rg ag or ack as grepprg if available
  set grepprg=rg\ --vimgrep\ --no-heading\ --smart-case
  set grepformat=%f:%l:%c:%m,%f:%l:%m
elseif executable('ag')
  set grepprg=ag\ --nogroup\ --column\ --smart-case\ --nocolor\ --follow
  set grepformat=%f:%l:%c:%m
elseif executable('ack')
  set grepprg=ack\ --nogroup\ --column\ --smart-case\ --nocolor\ --follow\ $*
  set grepformat=%f:%l:%c:%m
endif
" }}}

"           +--Disable hlsearch while loading viminfo
"           | +--Remember marks for last 500 files
"           | |    +--Remember up to 10000 lines in each register
"           | |    |      +- -Remember up to 1MB in each register
"           | |    |      |     +--Remember last 1000 search patterns
"           | |    |      |     |     +---Remember last 1000 commands
"           | |    |      |     |     |
"           v v    v      v     v     v
set viminfo=h,'500,<10000,s1000,/1000,:1000

" let g:netrw_liststyle=3                                  " netrw in treeview
" let g:netrw_fastbrowse=0                                 " make netrw faster
" let g:netrw_banner = 0                                   " noisy but helpful text

" }}}
" {{{ functions
function! s:adjust_window_height(minheight, maxheight) abort " {{{
  exe max([ min([ line('$'), a:maxheight ]), a:minheight ]) . 'wincmd _'
endfunction
" }}}
function! s:push_below_or_left() abort " {{{
  if winheight(0) / 2 < line('$')
    wincmd H
    vert resize 80
  else
    wincmd J
    call s:adjust_window_height(1, winheight(0) / 2)
  endif
endfunction
" }}}
function! s:diff_u() abort " {{{
  " shows a split with a diff of the current buffer
  let l:original = expand('%:p')
  if strlen(l:original) < 1
    echo 'no file on disk'
    return -1
  endif
  " TODO: get buffer without mangling newlines
  let l:changes = join(getline(1, '$'), "\n")."\n"
  let l:diff = system(printf('diff -u %s -', l:original), l:changes)
  if l:diff ==# ''
    echo 'no changes'
    return 0
  endif
  new | 0put =l:diff
  if empty(getline('$'))
    execute 'normal! Gddgg'
  endif
  call s:push_below_or_left()
  nnoremap <silent><buffer> q :<C-u>q<CR>
  nnoremap <silent><buffer> <Esc> :<C-u>q<CR>
  setlocal buftype=nofile bufhidden=wipe nomodified nobuflisted noswapfile readonly foldmethod=diff filetype=diff
  return 1
endfunction
" }}}
function! s:diff_write() abort " {{{
  " show split from DiffU() and prompt to save
  " TODO: suck less
  if s:diff_u() < 1
    return
  endif
  redraw!
  echo 'Save changes? '
  let l:char = nr2char(getchar())
  if l:char ==? 'y'
    bd | write!
  elseif l:char ==? 'q'
    bd
  endif
  redraw!
endfunction
" }}}
function! s:read_url(url) abort " {{{
  " opens a url in a new buffer, prompts for filetype
  if ! executable('curl')
    echo 'curl not found'
    return 0
  endif
  enew | put =system('curl -sL ' . a:url)
  if empty(getline('$'))
    execute 'normal! Gddgg'
  endif
  redraw!
  let l:newft = input('filetype? ')
  if strlen(l:newft) > 0
    execute 'set filetype=' . l:newft
  endif
  redraw!
endfunction
command! -bar -nargs=1 R call s:read_url("<args>")
" }}}
function! s:diff_url(url) abort " {{{
  " starts diffmode with the current buffer and a url
  " TODO: could be it beee any file
  if ! executable('curl')
    echo 'curl not found'
    return 0
  endif
  let l:difft = &filetype
  diffthis
  vnew | put =system('curl -sL ' . a:url)
  execute 'set ft=' . l:difft
  if empty(getline('$'))
    execute 'normal! Gddgg'
  endif
  redraw!
  diffthis | diffupdate
  redraw
endfunction
command! -bar -nargs=1 Rdiff call s:diff_url("<args>")
" }}}
function! s:toggle_gj_gk() abort " {{{
  if ! exists('g:togglegjgk') || g:togglegjgk == 0
    let g:togglegjgk = 1
    nnoremap j gj
    nnoremap k gk
    nnoremap gk k
    nnoremap gj j
    echo 'j/k swapped with gj/gk'
  else
    let g:togglegjgk = 0
    nunmap j
    nunmap k
    nunmap gk
    nunmap gj
    echo 'normal j/k'
  endif
endfunction
" }}}
function! MyFoldText() abort " {{{
  " courtesy Steve Losch
  let l:line = getline(v:foldstart)
  let l:nucolwidth = &foldcolumn + &number * &numberwidth
  let l:windowwidth = winwidth(0) - l:nucolwidth - 3
  let l:foldedlinecount = v:foldend - v:foldstart
  let l:onetab = strpart('          ', 0, &tabstop)
  let l:line = substitute(l:line, '\t', l:onetab, 'g')
  let l:line = strpart(l:line, 0, l:windowwidth - 2 - len(l:foldedlinecount))
  let l:fillcharcount = l:windowwidth - len(l:line) - len(l:foldedlinecount) - 2
  return l:line . ' ' . repeat(' ', l:fillcharcount)  . ' '. l:foldedlinecount
endfunction
" }}}
function! s:execute_macro_over_visual_range() abort " {{{
  echo '@'.getcmdline()
  execute ":'<,'>normal @".nr2char(getchar())
endfunction
" }}}
function! s:check_back_space() abort " {{{
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction
" }}}
" }}}
" {{{ custom commands and maps

" open file explorer with -
nnoremap <silent> - :<C-u>NvimTreeFocus<CR>

" make Y behave like C and D
nnoremap Y y$

" swap ` and ' since they are similar, but ' is closer to home-row and ignores mark column
nnoremap ' `
nnoremap ` '

" an attempt at exclusive folds
nnoremap zj zjzMzv
nnoremap zk zkzMzv
nnoremap za zazMzv

" easy tab size changing
nnoremap <leader>t2 :<C-u>setlocal ts=2 sw=2<CR>
nnoremap <leader>t4 :<C-u>setlocal ts=4 sw=4<CR>
nnoremap <leader>t8 :<C-u>setlocal ts=8 sw=8<CR>

" unimpaired-like expandtab toggle
nnoremap yoe :<C-u>set expandtab!<CR>

" expand %% in the command prompt to the current dir
cabbrev %% <C-R>=fnameescape(expand('%:h'))<CR>

" sudo write with :w!! " FIXME this doesn't work in nvim
cabbrev w!! w !sudo tee >/dev/null "%"

" quicker :s mappings with \very magic regex
" see also :h c_CTRL-R_CTRL-W
nnoremap <leader>s :<C-u>s///gc<left><left><left>
nnoremap <leader>S :<C-u>%s///gc<left><left><left>
xnoremap <leader>s :<C-u>'<'>s///gc<left><left>

nnoremap <leader>r :<C-u>s/<C-r><C-w>//gc<left><left><left>
nnoremap <leader>R :<C-u>s/<C-r><C-A>//gc<left><left><left>

xnoremap @ :<C-u>call s:execute_macro_over_visual_range()<CR>

" swap j/k with gj/gk
nnoremap <silent> <leader>tgj :<C-u>call s:toggle_gj_gk()<CR>

" insert timestamp with ctrl-t
inoremap <C-t> <C-R>=strftime('%c')<Left><Left>
cnoremap <C-t> <C-R>=strftime('%c')<Left><Left>

" common command typos
command! -bang Qa qa<bang>
command! -bang Wa bufdo W<bang>
command! -bang Wqa wqa<bang>

command! -bar -nargs=0 Write call s:diff_write()
command! -bar -nargs=0 DiffU call s:diff_u()
" nnoremap <silent> <Leader>d :<C-u>DiffU<CR>

" common typing mistakes
iabbrev functino function
iabbrev frmo from
iabbrev teh the
iabbrev seperate separate
" }}}
" {{{ autocmds
augroup Vim
  " always wrap autocmds in an augroup
  " reset the augroup so autocmds don't stack on reload
  autocmd!

  " reload vimrc on save (and refresh airline)
  autocmd BufWritePost ~/.vimrc
  \ source ~/.vimrc
  \ | if exists('*lightline#enable()') |
  \   call lightline#enable() |
  \ endif

  " restore last known position in file
  autocmd BufReadPost *
  \ if &ft != 'gitcommit' && line("'\"") > 0 && line("'\"") <= line('$') |
  \   execute 'normal! g`"zvzz' |
  \ endif

  " start git commits in insert mode with spelling and textwidth
  autocmd FileType gitcommit
  \ setlocal spell textwidth=72 |
  \ startinsert

  " use Q to close non-files (help, quickfix, etc)
  autocmd BufEnter *
  \ if &buftype != '' |
  \   nnoremap <silent><buffer> q :<C-u>bw<CR> |
  \ endif

  " open :help to the right at 80 columns
  autocmd FileType help
  \ wincmd L |
  \ vert resize 81

  " expand help when focused
  autocmd FileType help
  \ execute 'normal 0' |
  \ vert resize 81 |

  " make help small when unfocus
  autocmd BufLeave *
  \ if &filetype ==? 'help' |
  \   vert resize 10 |
  \ endif

  " make help small when vim resized
  autocmd VimResized help
  \ vert resize 10

  " theme overrides
  autocmd ColorScheme *
  \ hi CocWarningVirtualText cterm=bold ctermfg=3 ctermbg=0 |
  \ hi CocErrorVirtualText cterm=bold ctermfg=1 ctermbg=0 |
  \ hi Whitespace ctermfg=0 |
  \ hi CocHoverRange ctermbg=0 |
  \ hi NonText ctermfg=0 |
  \ hi SneakPluginTarget ctermfg=black ctermbg=red |
  \ hi SneakPluginScope ctermfg=black ctermbg=yellow
augroup END
" }}}

colorscheme noctu

" vim: foldmethod=marker foldlevel=0:
