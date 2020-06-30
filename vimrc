" TODO: more comments
scriptencoding utf8
filetype plugin indent on
let g:mapleader = "\<Space>"

" {{{ plugins
" {{{ init
let s:configdir = '~/.vim'
if has('nvim')
  let s:configdir = '~/.config/nvim'
endif

if empty(glob(s:configdir . '/bundle')) || empty(glob(s:configdir . '/autoload/plug.vim'))
  augroup InstallPlugins
    autocmd!
    autocmd VimEnter * call s:InstallPlugins()
  augroup END
  function! s:InstallPlugins() abort
    redraw!
    echo 'Install missing plugins? [y/N] '
    if nr2char(getchar()) ==? 'y'
      silent call system('mkdir -p ' . s:configdir . '/{autoload,bundle,cache,undo,backups,swaps}')
      silent call system('curl -fLo ' . s:configdir . '/autoload/plug.vim https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim')
      execute 'source ' . s:configdir . '/autoload/plug.vim'
      PlugInstall
    endif
    redraw!
  endfunction
endif

if ! empty(glob(s:configdir . '/bundle'))
call plug#begin(s:configdir . '/bundle')
" }}}
" {{{ text objects
Plug 'https://github.com/wellle/targets.vim'
Plug 'https://github.com/kana/vim-textobj-user'
Plug 'https://github.com/kana/vim-textobj-indent'
Plug 'https://github.com/kana/vim-textobj-function'
Plug 'https://github.com/kana/vim-textobj-line'
Plug 'https://github.com/kentaro/vim-textobj-function-php'
Plug 'https://github.com/thinca/vim-textobj-function-javascript'
Plug 'https://github.com/glts/vim-textobj-comment'
Plug 'https://github.com/reedes/vim-textobj-sentence'
Plug 'https://github.com/thinca/vim-textobj-between'
Plug 'https://github.com/kana/vim-textobj-line'
" }}}
" {{{ operators
Plug 'https://github.com/tpope/vim-surround'
Plug 'https://github.com/tpope/vim-commentary'
Plug 'https://github.com/tpope/vim-speeddating'
Plug 'https://github.com/tpope/vim-abolish'
Plug 'https://github.com/tpope/vim-repeat'
Plug 'https://github.com/tommcdo/vim-exchange'
Plug 'https://github.com/machakann/vim-highlightedyank'
" }}}
" {{{ searching
Plug 'https://github.com/justinmk/vim-sneak' " {{{
  let g:sneak#prompt = ''
  map <silent> f <Plug>Sneak_f
  map <silent> F <Plug>Sneak_F
  map <silent> t <Plug>Sneak_t
  map <silent> T <Plug>Sneak_T
  map <silent> ; <Plug>SneakNext
  map <silent> , <Plug>SneakPrevious
  augroup SneakPlugincolors
    autocmd!
    autocmd ColorScheme * hi SneakPluginTarget
    \ guifg=black guibg=red ctermfg=black ctermbg=red
    autocmd ColorScheme * hi SneakPluginScope
    \ guifg=black guibg=yellow ctermfg=black ctermbg=yellow
  augroup END
" }}}
Plug 'https://github.com/markonm/traces.vim'
Plug 'https://github.com/haya14busa/is.vim'
Plug 'https://github.com/bronson/vim-visual-star-search'
" }}}
" {{{ completion/building
" Plug 'zxqfl/tabnine-vim'
Plug 'https://github.com/SirVer/ultisnips' " {{{
let g:UltiSnipsExpandTrigger="<C-j>"
" }}}
Plug 'https://github.com/honza/vim-snippets'
Plug 'https://github.com/jiangmiao/auto-pairs'
Plug 'https://github.com/tpope/vim-endwise'
if has('nvim') || v:version >= 800
  Plug 'neoclide/coc.nvim' " {{{
  \ , {'tag': '*', 'branch': 'release'}

  let g:airline_section_error = '%{airline#util#wrap(airline#extensions#coc#get_error(),0)}'
  let g:airline_section_warning = '%{airline#util#wrap(airline#extensions#coc#get_warning(),0)}'

  inoremap <silent><expr> <c-space> coc#refresh()
  " Use `[c` and `]c` for navigate diagnostics
  nmap <silent> [c <Plug>(coc-diagnostic-prev)
  nmap <silent> ]c <Plug>(coc-diagnostic-next)

  " Remap keys for gotos
  nmap <silent> gd <Plug>(coc-definition)
  nmap <silent> gy <Plug>(coc-type-definition)
  nmap <silent> gi <Plug>(coc-implementation)
  nmap <silent> gr <Plug>(coc-references)

  " Use K for show documentation in preview window
  nnoremap <silent> K :call <SID>show_documentation()<CR>

  function! s:show_documentation() abort
    if &filetype == 'vim'
      execute 'h '.expand('<cword>')
    else
      call CocAction('doHover')
    endif
  endfunction

  " Use `:Format` for format current buffer
  command! -nargs=0 Format :call CocAction('format')

  " Use `:Fold` for fold current buffer
  command! -nargs=? Fold :call     CocAction('fold', <f-args>)


  " Remap for rename current word
  nmap <leader>Cr <Plug>(coc-rename)

  " Remap for format selected region
  vmap <leader>Cfo  <Plug>(coc-format-selected)

  " Remap for do codeAction of selected region, ex: `<leader>aap` for current paragraph
  vmap <leader>Ca  <Plug>(coc-codeaction-selected)
  nmap <leader>Ca  <Plug>(coc-codeaction-selected)

  " Remap for do codeAction of current line
  nmap <leader>Cca  <Plug>(coc-codeaction)
  " Fix autofix problem of current line
  nmap <leader>Cf  <Plug>(coc-fix-current)

  " Using CocList
  " Show all diagnostics
  nnoremap <silent> <space>Ca  :<C-u>CocList diagnostics<cr>
  " Manage extensions
  nnoremap <silent> <space>Ce  :<C-u>CocList extensions<cr>
  " Show commands
  nnoremap <silent> <space>Cco  :<C-u>CocList commands<cr>
  " Find symbol of current document
  nnoremap <silent> <space>Co  :<C-u>CocList outline<cr>
  " Search workspace symbols
  nnoremap <silent> <space>Cs  :<C-u>CocList -I symbols<cr>
  " Do default action for next item.
  nnoremap <silent> <space>Cj  :<C-u>CocNext<CR>
  " Do default action for previous item.
  nnoremap <silent> <space>Ck  :<C-u>CocPrev<CR>
  " Resume latest coc list
  nnoremap <silent> <space>Cp  :<C-u>CocListResume<CR>

  function! s:cocHover() abort
    call CocActionAsync('doHover')
    call CocActionAsync('highlight')
  endfunction

  augroup Coc
    autocmd!
    " Highlight symbol under cursor on CursorHold
    autocmd CursorHold * silent call s:cocHover()
    " Setup formatexpr specified filetype(s).
    autocmd FileType javascript,javascript.jsx,jsx,typescript,json setl formatexpr=CocAction('formatSelected')
    " Update signature help on jump placeholder
    autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
  augroup END
  " }}}
elseif has('nvim') || has('lambda')
  Plug 'https://github.com/w0rp/ale' " {{{
    let g:ale_lint_delay = 500
    let g:ale_open_list = 0
    let g:ale_statusline_format = [ '✘ %d', '∆ %d', '' ]
    " let g:ale_sign_error = ''
    " let g:ale_sign_warning = ''
    let g:ale_sign_error = '�'
  let g:ale_sign_warning = '��'
    let g:ale_echo_msg_error_str = 'E'
    let g:ale_echo_msg_warning_str = 'W'
    let g:ale_echo_msg_format = '%linter% %code% [%severity%] %s'
    let g:ale_linter_aliases = {
    \ 'sugarss': [ 'css' ],
    \ }
    let g:ale_linters = {
    \ 'haskell': [],
    \ }
    augroup AleLint
      autocmd!
      autocmd User ALELint lwindow
      autocmd FileType javascript,jsx,javascript.jsx
            \ nnoremap <silent><buffer> <Leader>af :<C-u>ALEFix eslint<CR>
    augroup END
  " }}}
else
  Plug 'https://github.com/scrooloose/syntastic' " {{{
    let g:syntastic_enable_signs = 1
    let g:syntastic_auto_loc_list = 1
    let g:syntastic_check_on_open = 1
    let g:syntastic_error_symbol = '✗'
    let g:syntastic_style_error_symbol = '✠'
    let g:syntastic_warning_symbol = '∆'
    let g:syntastic_style_warning_symbol = '≈'
    let g:syntastic_html_tidy_ignore_errors = [' proprietary attribute "ng-']
    let g:syntastic_check_on_wq = 0
    let g:syntastic_auto_jump = 3

    nnoremap <silent> <Leader>c :<C-u>SyntasticCheck<CR>
  " }}}
endif
" }}}
" {{{ formatting
Plug 'https://github.com/christoomey/vim-titlecase' " {{{
  let g:titlecase_map_keys = 0
  nmap <Leader>gt <Plug>Titlecase
  vmap <Leader>gt <Plug>Titlecase
  nmap <Leader>gT <Plug>TitlecaseLine
" }}}
Plug 'https://github.com/junegunn/vim-easy-align' " {{{
  nmap <Leader>al <Plug>(LiveEasyAlign)
  vmap <Leader>al <Plug>(LiveEasyAlign)
" }}}
Plug 'https://github.com/reedes/vim-pencil' " {{{
  let g:pencil#wrapModeDefault = 'soft'
  let g:pencil#textwidth = 80
  let g:pencil#mode_indicators = {'hard': 'H', 'auto': 'A', 'soft': 'S', 'off': '',}

  augroup Pencil
    autocmd!
    autocmd FileType markdown,liquid
    \ call pencil#init({ 'wrap': 'soft' })
    autocmd FileType text
    \ call pencil#init({ 'wrap': 'hard', 'autoformat': 0 })
  augroup END
" }}}
Plug 'https://github.com/dahu/Insertlessly' " {{{
  let g:insertlessly_cleanup_trailing_ws = 0
  let g:insertlessly_cleanup_all_ws = 0
  let g:insertlessly_insert_spaces = 0
" }}}
Plug 'https://github.com/editorconfig/editorconfig-vim'
Plug 'https://github.com/tpope/vim-sleuth'
" }}}
" {{{ appearance
Plug 'https://github.com/vim-airline/vim-airline' " {{{
  Plug 'https://github.com/vim-airline/vim-airline-themes'
  let g:airline_theme = 'hybridline'
  let g:airline_powerline_fonts = 1
  let g:airline#extensions#branch#enabled = 1
  let g:airline#extensions#tabline#enabled = 1
  let g:airline#extensions#tabline#fnamemod = ':t'
  let g:airline#extensions#whitespace#enabled = 0
  let g:airline#extensions#wordcount#enabled = 0
  let g:airline_skip_empty_sections = 1
  let g:airline_mode_map =
  \ { '__' : '-'
  \ , 'n'  : 'N'
  \ , 'i'  : 'I'
  \ , 'R'  : 'R'
  \ , 'c'  : 'C'
  \ , 'v'  : 'V'
  \ , 'V'  : 'V'
  \ , '' : 'V'
  \ , 's'  : 'S'
  \ , 'S'  : 'S'
  \ , '' : 'S'
  \ }
  " let g:airline#extensions#default#layout =
  " \ [ [ 'a', 'b', 'c' ]
  " \ , [ 'x', 'y', 'error', 'warning'
  " \ ] ]
  " let g:airline_extensions = [ 'branch', 'tabline', 'nrrwrgn', 'hunks' ]
  function! AirlineInit() abort
    let g:airline_section_z = g:airline_section_y
    let g:airline_section_y = g:airline_section_x
    " let g:airline_section_x = '%{PencilMode()} %{gutentags#statusline("[Generating ctags...]")}'
    let g:airline_section_x = '%{PencilMode()} '
  endfunction
  augroup Airline
    autocmd!
    autocmd User AirlineAfterInit call AirlineInit()
  augroup END
" }}}
Plug 'https://github.com/junegunn/limelight.vim' " {{{
  let g:limelight_conceal_ctermfg = 'black'
" }}}
Plug 'https://github.com/junegunn/goyo.vim' " {{{
  function! s:goyo_enter() abort
    set showmode scrolloff=999
    if exists('$TMUX')
      silent !tmux set status off
      augroup Distractions
        autocmd!
        autocmd VimLeavePre * silent! !tmux set -q status on
      augroup END
    endif
  endfunction
  function! s:goyo_leave() abort
    set noshowmode scrolloff=5
    if exists('$TMUX')
      silent !tmux set status on
      augroup Distractions
        autocmd!
      augroup END
    endif
  endfunction
  augroup Goyo
    autocmd!
    autocmd User GoyoEnter nested call <SID>goyo_enter()
    autocmd User GoyoLeave nested call <SID>goyo_leave()
  augroup END
  nnoremap <Leader>df :<C-u>Goyo<CR>
" }}}
Plug 'https://github.com/mhinz/vim-startify' " {{{
  let g:startify_change_to_vcs_root = 1

  " function! s:filter_header(str) abort
  "   return map(split(system('figlet -f future "'. a:str .'"'), '\n'), '"         ". v:val') + [ '', '' ]
  " endfunction

  if has('nvim')
    " let g:startify_custom_header = s:filter_header('NeoVim')
    let g:startify_custom_header =
    \ [ '        ┏┓╻┏━╸┏━┓╻ ╻╻┏┳┓'
    \ , '        ┃┗┫┣╸ ┃ ┃┃┏┛┃┃┃┃'
    \ , '        ╹ ╹┗━╸┗━┛┗┛ ╹╹ ╹'
    \ , ''
    \ ]
  else
    " let g:startify_custom_header = s:filter_header('Vim')
    let g:startify_custom_header =
    \ [ '        ╻ ╻╻┏┳┓'
    \ , '        ┃┏┛┃┃┃┃'
    \ , '        ┗┛ ╹╹ ╹'
    \ , ''
    \ ]
  endif
" }}}
Plug 'https://github.com/reedes/vim-thematic' " {{{
  let g:thematic#defaults = { 'background': 'dark' }
  let g:thematic#themes =
  \ { 'gui':
  \   { 'colorscheme': 'atom-dark-256'
  \   , 'airline': 'noctu'
  \   , 'typeface': 'Fantasque Sans Mono'
  \   , 'font-size': 10
  \   }
  \ , 'term':
  \   { 'colorscheme': 'noctu'
  \   , 'airline': 'hybridline'
  \   }
  \ }
  if has('gui_running')
    let g:thematic#theme_name = 'gui'
    set guioptions-=l
    set guioptions-=L
    set guioptions-=r
    set guioptions-=T
    set guioptions-=m
    set guioptions+=c
  else
    let g:thematic#theme_name = 'term'
  endif
" }}}
Plug 'https://github.com/noahfrederick/vim-noctu'
Plug 'https://github.com/gosukiwi/vim-atom-dark'
Plug 'https://github.com/Yggdroot/indentLine' " {{{
let g:indentLine_fileTypeExclude = [
\   'help',
\   'startify',
\ ]
" }}}
Plug 'https://github.com/junegunn/rainbow_parentheses.vim' " {{{
  augroup rainbow_lisp
    autocmd!
    autocmd FileType lisp,clojure,scheme RainbowParentheses
  augroup END
" }}}
Plug 'https://github.com/DanielFGray/DistractionFree.vim' " {{{
  let g:distraction_free#toggle_tmux = 1
  function! s:distractions_off() abort
    set showmode showcmd scrolloff=999
  endfunction
  function! s:distractions_on() abort
    set noshowmode noshowcmd scrolloff=5
  endfunction
  augroup DF
    autocmd!
    autocmd User DistractionsOn nested call <SID>distractions_on()
    autocmd User DistractionsOff nested call <SID>distractions_off()
  augroup END
" }}}
" }}}
" {{{ prose
Plug 'https://github.com/reedes/vim-litecorrect' " {{{
  augroup LiteCorrect
    autocmd!
    autocmd FileType markdown,text,liquid
    \ call litecorrect#init()
  augroup END
" }}}
Plug 'https://github.com/reedes/vim-lexical' " {{{
  " curl -L http://www.gutenberg.org/files/3202/files/mthesaur.txt -o ~/.vim/thesaurus/mthesaur.txt --create-dirs
  let g:lexical#dictionary = [ '/usr/share/dict/cracklib-small' ]
  augroup Lexical
    autocmd!
    autocmd FileType markdown,text,liquid
    \ call lexical#init()
  augroup END
" }}}
Plug 'https://github.com/reedes/vim-wordy' " {{{
  augroup Wordy
    autocmd!
    autocmd FileType markdown,text,liquid
    \ nnoremap <buffer> [w :<C-u>PrevWordy<CR>
    autocmd FileType markdown,text,liquid
    \ nnoremap <buffer> ]w :<C-u>NextWordy<CR>
  augroup END
" }}}
" }}}
" {{{ misc/unorganized
Plug 'https://github.com/Shougo/vimproc' " {{{
\, {'do': 'make'}
" }}}
Plug 'https://github.com/tpope/vim-sensible'
Plug 'https://github.com/tpope/vim-unimpaired'
Plug 'https://github.com/tpope/vim-eunuch'
Plug 'https://github.com/vim-utils/vim-husk'
Plug 'https://github.com/chrisbra/NrrwRgn'
Plug 'https://github.com/Shougo/echodoc' " {{{
  let g:echodoc_enable_at_startup = 1
" }}}
Plug 'https://github.com/jeetsukumaran/vim-filebeagle' " {{{
  let g:filebeagle_suppress_keymaps = 1
  map <silent> - <Plug>FileBeagleOpenCurrentBufferDir
" }}}
Plug 'https://github.com/mhinz/vim-sayonara'
Plug 'https://github.com/AndrewRadev/splitjoin.vim'
Plug 'https://github.com/sheerun/vim-polyglot'
Plug 'https://github.com/junegunn/fzf' " {{{
\, { 'dir': '~/.fzf', 'do': './install --all' }
" }}}
Plug 'https://github.com/junegunn/fzf.vim' " {{{
  nnoremap <Leader>F :<C-u>Files<CR>
" }}}
Plug 'https://github.com/chilicuil/vim-sprunge' " {{{
  nnoremap <Leader>pa <Plug>Sprunge
  xnoremap <Leader>pa <Plug>Sprunge
  let g:sprunge_cmd = 'tekup -'
" }}}
Plug 'https://github.com/simnalamburt/vim-mundo' " {{{
  let g:mundo_width = 60
  let g:mundo_preview_height = 40
  let g:mundo_right = 0

  nnoremap <silent> <leader>u :<C-U>MundoToggle<CR>
" }}}
" Plug 'https://github.com/mbbill/undotree' " {{{
"   let g:undotree_WindowLayout = 4
"   let g:undotree_SetFocusWhenToggle = 1
"   let g:undotree_SplitWidth = 60
"   nnoremap <silent> <Leader>u :<C-u>UndotreeToggle<CR>
"   function! g:Undotree_CustomMap() abort
"       nmap <buffer> k <plug>UndotreeGoNextState
"       nmap <buffer> j <plug>UndotreeGoPreviousState
"       nmap <buffer> <Esc> <plug>UndotreeClose
"   endfunc
" " }}}
" Plug 'https://github.com/sjl/gundo.vim' " {{{
"   nnoremap <silent> <Leader>u :<C-u>GundoToggle<CR>
"   let g:gundo_right = 1
"   let g:gundo_width = 80
"   let g:gundo_preview_height = 20
" " }}}
Plug 'https://github.com/chilicuil/vim-sprunge' " {{{
  let g:sprunge_cmd = 'curl -s -n -F "f:1=<-" http://ix.io'
" }}}
" Plug 'https://github.com/ludovicchabant/vim-gutentags'
Plug 'https://github.com/metakirby5/codi.vim' " {{{
nnoremap <Leader>CC :<C-u>Codi!!<CR>
  let g:codi#rightalign = 1
  let g:codi#rightsplit = 0
  let g:codi#aliases =
  \ { 'javascript.jsx': 'javascript'
  \ }
" }}}
Plug 'https://github.com/vim-scripts/loremipsum'
Plug 'https://github.com/t9md/vim-quickhl' " {{{
  nnoremap <silent> <leader>th :<C-u>QuickhlCwordToggle<CR>
" }}}
" Plug 'https://github.com/mickaobrien/vim-stackoverflow'
Plug 'https://github.com/hecal3/vim-leader-guide' " {{{
  nnoremap <silent> <Leader> :<c-u>LeaderGuide '<Space>'<CR>
  let g:leaderGuide_default_group_name = '+group'
  let g:leaderGuide_hspace = 2
  let s:leaderGuide_max_desc_len = 30

  function! s:leaderGuide_displayfunc() abort
    " Kill ending <cr>
    let g:leaderGuide#displayname = substitute(g:leaderGuide#displayname, '<CR>$', '', 'i')
    " Kill beginning <esc>
    let g:leaderGuide#displayname = substitute(g:leaderGuide#displayname, '^<Esc>', '', 'i')
    let g:leaderGuide#displayname = substitute(g:leaderGuide#displayname, '<Esc>', '⇬', 'i')
    let g:leaderGuide#displayname = substitute(g:leaderGuide#displayname, '<CR>', '↵', 'i')
    " Kill beginning <plug>
    let g:leaderGuide#displayname = substitute(g:leaderGuide#displayname, '^<plug>(\?\([^)]*\))\?', '\1', 'i')
    " Truncate to s:leaderGuide_max_desc_len chars or less
    if len(g:leaderGuide#displayname) > s:leaderGuide_max_desc_len
      let g:leaderGuide#displayname =
      \ g:leaderGuide#displayname[:s:leaderGuide_max_desc_len-1] ."…"
    endif
  endfunction
  let g:leaderGuide_displayfunc = [function("s:leaderGuide_displayfunc")]

  function! s:map_leaderGuides(maps, l) abort
    for k in a:l
      let g = k == '<leader>' ? g:mapleader : k
      if a:maps =~ 'n'
        exe 'nnoremap <silent> ' . k . ' :<c-u>LeaderGuide ''' . g . '''<CR>'
      endif
      if a:maps =~ 'v'
        exe 'xnoremap <silent> ' . k . ' :<c-u>LeaderGuideVisual ''' . g . '''<CR>'
      endif
    endfor
  endfunction

  call s:map_leaderGuides('n', [ 'co' ])
  call s:map_leaderGuides('nv', [ '<leader>', '[', ']' ])
  " }}}
" }}}
" {{{ unite.vim
Plug 'https://github.com/Shougo/unite.vim'
Plug 'https://github.com/Shougo/neoyank.vim'
Plug 'https://github.com/Shougo/unite-help'
Plug 'https://github.com/Shougo/unite-outline'
Plug 'https://github.com/Shougo/unite-session'
Plug 'https://github.com/Shougo/neomru.vim'
Plug 'https://github.com/Shougo/context_filetype.vim'
Plug 'https://github.com/tsukkee/unite-tag'
Plug 'https://github.com/osyo-manga/unite-filetype'
Plug 'https://github.com/thinca/vim-unite-history'
Plug 'https://github.com/kopischke/unite-spell-suggest'
" Plug 'https://github.com/moznion/unite-git-conflict.vim'
Plug 'https://github.com/lambdalisue/vim-gista-unite'
Plug 'https://github.com/kmnk/vim-unite-giti'
if has('nvim')
  Plug 'https://github.com/shougo/denite.nvim' " {{{
  \ , { 'do': ':UpdateRemotePlugins' }
  " }}}
  Plug 'https://github.com/neoclide/coc-denite'
  function! s:denite_my_settings() abort
    nnoremap <silent><buffer><expr> <CR>
    \ denite#do_map('do_action')
    nnoremap <silent><buffer><expr> d
    \ denite#do_map('do_action', 'delete')
    nnoremap <silent><buffer><expr> p
    \ denite#do_map('do_action', 'preview')
    nnoremap <silent><buffer><expr> <esc>
    \ denite#do_map('quit')
    nnoremap <silent><buffer><expr> q
    \ denite#do_map('quit')
    nnoremap <silent><buffer><expr> a
    \ denite#do_map('open_filter_buffer')
    nnoremap <silent><buffer><expr> i
    \ denite#do_map('open_filter_buffer')
    nnoremap <silent><buffer><expr> <Space>
    \ denite#do_map('toggle_select').'j'
  endfunction
  augroup Denite
    au!
    autocmd FileType denite call s:denite_my_settings()
  augroup END
endif
" }}}
" {{{ git
Plug 'https://github.com/tpope/vim-fugitive' " {{{
  nnoremap <Leader>gs :<C-u>Gstatus<CR>:<C-u>call PushBelowOrLeft()<CR><C-L>
  nnoremap <Leader>gd :<C-u>Gdiff<CR>
  nnoremap <Leader>gc :<C-u>Gcommit<CR>:<C-u>call PushBelowOrLeft()<CR><C-L>
  nnoremap <Leader>gb :<C-u>Gblame<CR>
  nnoremap <Leader>gp :<C-u>Git push<CR>
" }}}
Plug 'https://github.com/esneider/YUNOcommit.vim' " {{{
  let g:YUNOcommit_after = 5
" }}}
Plug 'https://github.com/airblade/vim-gitgutter' " {{{
  let g:gitgutter_map_keys = 0
  nnoremap <silent> [h :<C-u>GitGutterPrevHunk<CR>zMzvzz
  nnoremap <silent> ]h :<C-u>GitGutterNextHunk<CR>zMzvzz
  nnoremap <silent> <Leader>hs :<C-u>GitGutterStageHunk<CR>
  nnoremap <silent> <Leader>gu :<C-u>GitGutterUndoHunk<CR>
  nnoremap <silent> <Leader>hp :<C-u>GitGutterPreviewHunk<CR>
" }}}
Plug 'https://github.com/lambdalisue/vim-gista'
Plug 'https://github.com/int3/vim-extradite'
" }}}
" {{{ tmux
Plug 'https://github.com/tmux-plugins/vim-tmux'
Plug 'https://github.com/wellle/tmux-complete.vim'
Plug 'https://github.com/mhinz/vim-tmuxify' " {{{
  let g:tmuxify_map_prefix = '<Leader>m'
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
" }}}
" {{{ latex
Plug 'https://github.com/LaTeX-Box-Team/LaTeX-Box'
" Plug 'https://github.com/xuhdev/vim-latex-live-preview'
" }}}
" {{{ html/css
Plug 'https://github.com/mattn/emmet-vim' " {{{
  \, { 'for': [ 'html', 'javascript.jsx' ] }
  let g:user_emmet_settings = {
  \   'javascript.jsx' : {
  \       'extends' : 'jsx',
  \   },
  \ }
  " }}}
" Plug 'https://github.com/tmhedberg/matchit'
Plug 'https://github.com/tpope/vim-liquid'
Plug 'https://github.com/tpope/vim-ragtag' " {{{
  let g:ragtag_global_maps = 1
" }}}
Plug 'https://github.com/stephenway/postcss.vim'
Plug 'https://github.com/hhsnopek/vim-sugarss'
function! BuildComposer(info) abort " {{{
  if a:info.status != 'unchanged' || a:info.force
    if has('nvim')
      !cargo build --release
    else
      !cargo build --release --no-default-features --features json-rpc
    endif
  endif
endfunction
" }}}
Plug 'https://github.com/euclio/vim-markdown-composer' " {{{
  \, { 'do': function('BuildComposer') }
  let g:markdown_composer_browser = 'x-www-browser'
  let g:markdown_composer_open_browser = 0
  let g:markdown_composer_autostart = 0
" }}}
" }}}
" {{{ javascript
  " Plug 'https://github.com/moll/vim-node'
  " Plug 'https://github.com/elzr/vim-json' " {{{
    let g:vim_json_syntax_conceal = 0
  " }}}
  " Plug 'https://github.com/othree/yajs.vim'
  " Plug 'https://github.com/othree/javascript-libraries-syntax.vim'
  " Plug 'https://github.com/othree/jspc.vim'
  " Plug 'https://github.com/marijnh/tern_for_vim' " {{{
  " \,{ 'do': 'npm install'
  " \ , 'for': ['javascript', 'javascript.jsx']
  " \ }
  "   let g:tern#command = ['tern']
  "   let g:tern#arguments = ['--persistent']
  "   let g:tern_show_signature_in_pum = 1
  "   let g:tern#filetypes = [
  "   \ 'jsx',
  "   \ 'javascript.jsx',
  "   \ ]
  " " }}}
  if has ('nvim')
    " Plug 'https://github.com/steelsojka/deoplete-flow'
    " Plug 'https://github.com/carlitux/deoplete-ternjs'
  endif
  " Plug 'https://github.com/wokalski/autocomplete-flow'
  " Plug 'https://github.com/heavenshell/vim-jsdoc' " {{{
  "   let g:jsdoc_enable_es6 = 1
  "   augroup JsDoc
  "     autocmd!
  "     autocmd FileType javascript
  "     \ nnoremap <buffer> <Leader>jd <Plug>(jsdoc)
  "   augroup END
  " " }}}
  Plug 'https://github.com/samuelsimoes/vim-jsx-utils' " {{{
    augroup JSXutils
      au!
      autocmd FileType javascript,javascript.jsx
      \ nnoremap <leader>ja :call JSXEncloseReturn()<CR>
      autocmd FileType javascript
      \ nnoremap <leader>ji :call JSXEachAttributeInLine()<CR>
      autocmd FileType javascript
      \ nnoremap <leader>je :call JSXExtractPartialPrompt()<CR>
      autocmd FileType javascript
      \ nnoremap <leader>jc :call JSXChangeTagPrompt()<CR>
      autocmd FileType javascript
      \ xnoremap <silent> at :call JSXSelectTag()<CR>
    augroup END
  " }}}
  Plug 'epilande/vim-es2015-snippets'
  Plug 'epilande/vim-react-snippets'
  Plug 'https://github.com/neoclide/vim-jsx-improve'
" }}}
" {{{ haskell
Plug 'https://github.com/raichoo/purescript-vim'
Plug 'https://github.com/parsonsmatt/intero-neovim'
" Plug 'https://github.com/eagletmt/ghcmod-vim' " {{{
" augroup GhcMod
"   au!
"   autocmd FileType haskell
"   \ nnoremap <buffer><silent> <leader>hw :GhcModTypeInsert<CR>
"   autocmd FileType haskell
"   \ nnoremap <buffer><silent> <leader>hs :GhcModSplitFunCase<CR>
"   autocmd FileType haskell
"   \ nnoremap <buffer><silent> <leader>hq :GhcModType<buffer><CR>
"   autocmd FileType haskell
"   \ nnoremap <buffer><silent> <leader>he :GhcModTypeClear<CR>
" augroup END
" " }}}
" Plug 'https://github.com/eagletmt/neco-ghc'
" Plug 'https://github.com/Twinside/vim-hoogle' " {{{
"   augroup Hoogle
"     au!
"     autocmd FileType haskell
"     \ nnoremap <buffer> <leader>hh :Hoogle<Space>
"     autocmd FileType haskell
"     \ nnoremap <buffer> <Leader>hC :HoogleClose<CR>
"     autocmd FileType haskell
"     \ nnoremap <buffer> <Lewader>hl :HoogleLine<CR>
"   augroup END
" " }}}
" Plug 'https://github.com/enomsg/vim-haskellConcealPlus'
" Plug 'https://github.com/mpickering/hlint-refactor-vim' " {{{
"   let g:hlintRefactor#disableDefaultKeybindings = 1
" " }}}
" }}}
" " {{{ rust
" Plug 'https://github.com/rust-lang/rust.vim'
" Plug 'https://github.com/racer-rust/vim-racer'
" " }}}
" " {{{ python
" if has('nvim')
"   Plug 'zchee/deoplete-jedi'
" " else
" " Plug 'https://github.com/davidhalter/jedi-vim'
" endif
" " }}}
" " {{{ elixir
" Plug 'https://github.com/slashmili/alchemist.vim'
" Plug 'https://github.com/c-brenn/phoenix.vim'
" " }}}
" {{{ elm
" Plug 'https://github.com/lambdatoast/elm.vim'
Plug 'https://github.com/ElmCast/elm-vim'
" }}}
" " {{{ clojure
" Plug 'https://github.com/tpope/vim-fireplace'
" Plug 'https://github.com/bhurlow/vim-parinfer'
" " }}}
call plug#end()
endif
" {{{ unite settings
    let g:unite_data_directory = '~/.vim/cache/unite'
    let g:unite_force_overwrite_statusline = 0
    let g:unite_enable_start_insert = 1
    if executable('ag')
      let g:unite_source_grep_command = 'ag'
      let g:unite_source_grep_default_opts = '--nocolor --nogroup --hidden'
      let g:unite_source_grep_recursive_opt = ''
      let g:unite_source_rec_async_command = [ 'ag', '--follow', '--nocolor', '--nogroup', '--hidden', '-l' ]
    elseif executable('ack')
      let g:unite_source_grep_command = 'ack'
      let g:unite_source_grep_default_opts = '--no-heading --no-color'
      let g:unite_source_grep_recursive_opt = ''
      let g:unite_source_rec_async_command = [ 'ack', '-f', '--nofilter' ]
    endif

    call unite#filters#sorter_default#use([ 'sorter_rank' ])
    call unite#filters#matcher_default#use([ 'matcher_fuzzy' ])
    call unite#set_profile('files', 'context.smartcase', 1)
    call unite#custom#source('line,outline', 'matchers', 'matcher_regexp')
    call unite#custom#profile('default', 'context', {
    \   'prompt_direction': 'below',
    \   'direction': 'dynamicbottom',
    \   'start_insert': 1,
    \   'prompt': ' ',
    \   'prompt_focus': 1,
    \   'force_redraw': 1,
    \   'no_empty': 1,
    \   'winheight': 10,
    \   'enable_start_insert': 1,
    \ })
    " \   'no_split': 1,
    " \   'prompt_direction': 'top',

  nnoremap <silent> <Leader>r        :<C-u>Unite -buffer-name=register register<CR>
  nnoremap <silent> <Leader>y        :<C-u>Unite -buffer-name=yank     history/yank<CR>
  nnoremap <silent> <Leader>o        :<C-u>Unite -buffer-name=outline  outline<CR>
  nnoremap <silent> <Leader>/        :<C-u>Unite -buffer-name=grep     grep<CR>
  nnoremap <silent> <Leader>ta       :<C-u>Unite -buffer-name=tag      tag tag/file<CR>
  nnoremap <silent> <Leader>b        :<C-u>Unite -buffer-name=buffer   buffer neomru/file file<CR>
  nnoremap <silent> <Leader>f        :<C-u>Unite -buffer-name=files    jump_point file_point file/async neomru/file file/new<CR>
  nnoremap <silent> <Leader>l        :<C-u>Unite -buffer-name=line     line<CR>
  nnoremap <silent> z=               :<C-u>Unite -buffer-name=spell    spell_suggest<CR>
  nnoremap <silent> <Leader>gi       :<C-u>Unite -buffer-name=gista    gista<CR>
  nnoremap <silent> <Leader>gg       :<C-u>Unite -buffer-name=giti     giti<CR>

  if exists(':Denite')
    nnoremap <silent> <Leader><Leader> :<C-u>Denite mapping command function<CR>
    nnoremap <silent> <Leader>;        :<C-u>Denite command_history command function<CR>
  else
    nnoremap <silent> <Leader><Leader> :<C-u>Unite -buffer-name=mapping  mapping command function<CR>Space
    nnoremap <silent> <Leader>;        :<C-u>Unite -buffer-name=command  history/command mapping command function<CR>
  endif

  augroup Unite
    autocmd!
    autocmd FileType unite call s:unite_my_settings()
  augroup END

  function! s:unite_my_settings()
    imap <buffer>               <Esc> <Plug>(unite_exit)
    nmap <buffer>               <Esc> <Plug>(unite_exit)
    nnoremap <silent><buffer><expr> l unite#smart_map('l', unite#do_action('default'))
    imap <buffer><expr> j   unite#smart_map('j', '')
    imap <buffer><expr> x   unite#smart_map('x', "\<Plug>(unite_quick_match_jump)")
    imap <buffer> <TAB>     <Plug>(unite_select_next_line)
    imap <buffer> <C-w>     <Plug>(unite_delete_backward_path)
    imap <buffer> '         <Plug>(unite_quick_match_default_action)
    nmap <buffer> '         <Plug>(unite_quick_match_default_action)
    nmap <buffer> x         <Plug>(unite_quick_match_jump)
    nmap <buffer> <C-z>     <Plug>(unite_toggle_transpose_window)
    imap <buffer> <C-z>     <Plug>(unite_toggle_transpose_window)
    nmap <buffer> <C-j>     <Plug>(unite_toggle_auto_preview)
    nmap <buffer> <C-r>     <Plug>(unite_narrowing_input_history)
    imap <buffer> <C-r>     <Plug>(unite_narrowing_input_history)

    let l:unite = unite#get_current_unite()
    if l:unite.profile_name ==# 'search'
      nnoremap <silent><buffer><expr> r unite#do_action('replace')
    else
      nnoremap <silent><buffer><expr> r unite#do_action('rename')
    endif

    nnoremap <silent><buffer><expr> cd unite#do_action('lcd')
    nnoremap <buffer><expr> S unite#mappings#set_current_sorters( empty(unite#mappings#get_current_sorters()) ? [ 'sorter_reverse' ] : [])

    " Runs 'split' action by <C-s>.
    imap <silent><buffer><expr> <C-s> unite#do_action('split')
    imap <silent><buffer><expr> <C-v> unite#do_action('vsplit')
  endfunction

" }}}
" }}}
" {{{ general settings
" TODO: more organizing
syntax on

set updatetime=300
set backupcopy=yes
set mouse=n
set number relativenumber
set colorcolumn=80
set cursorline cursorcolumn
set hlsearch incsearch
set infercase
set backspace=indent,eol,start
set nowrap
set showmatch
set equalalways splitright
set wildmenu wildcharm=<C-Z>
set switchbuf=useopen,usetab
set tabstop=2 shiftwidth=2 expandtab
set foldmethod=marker foldopen-=block foldtext=MyFoldText()
set ruler rulerformat=%32(%=\:b%n%y%m%r%w\ %l,%c%V\ %P%)
set laststatus=2
set showcmd noshowmode
set hidden
set list listchars=tab:\|\ ,trail:★,extends:»,precedes:«,nbsp:•
" set list listchars=tab:\›\ ,trail:★,extends:»,precedes:«,nbsp:•
" set listchars+=eol:¬
set fillchars=stl:\ ,stlnc:\ ,vert:\ ,fold:\ ,diff:\
set lazyredraw
set autoread
set report=0
set confirm
set modeline modelines=2
set scrolloff=5
set t_Co=256
set shortmess+=I
set ttimeoutlen=25
set background=dark
try
  set cryptmethod=blowfish
  set cryptmethod=blowfish2
catch | endtry
set sessionoptions-=options
set diffopt=vertical
set undofile undodir=~/.vim/undo// undoreload=10000 undolevels=1000
set backupdir=~/.vim/backups//
set directory=~/.vim/swaps//

if executable('ag')
  set grepprg=ag\ --nogroup\ --column\ --smart-case\ --nocolor\ --follow
  set grepformat=%f:%l:%c:%m
elseif executable('ack')
  set grepprg=ack\ --nogroup\ --column\ --smart-case\ --nocolor\ --follow\ $*
  set grepformat=%f:%l:%c:%m
endif

if has('gui_running')
  set guioptions-=LrbTm
endif
" }}}
" {{{ functions

function! UrlToScriptTag() abort " {{{
  normal ysiW"Isrc=diWAscript,�kl pa type="text/javascript^j
endfunction
" }}}

function! s:DiffU() abort " {{{
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
  call PushBelowOrLeft()
  nnoremap <silent><buffer> q :<C-u>q<CR>
  nnoremap <silent><buffer> <Esc> :<C-u>q<CR>
  setlocal buftype=nofile bufhidden=wipe nomodified nobuflisted noswapfile readonly foldmethod=diff filetype=diff
  return 1
endfunction
command! -bar -nargs=0 DiffU call s:DiffU()
" nnoremap <silent> <Leader>d :<C-u>DiffU<CR>
" }}}

function! DiffWrite() abort " {{{
  " show split from DiffU() and prompt to save
  " TODO: suck less
  if s:DiffU() < 1
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
command! -bar -nargs=0 W call DiffWrite()
" nnoremap <silent> <Leader>w :<C-u>W<CR>
" }}}

function! s:ReadUrl(url) abort " {{{
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
command! -bar -nargs=1 R call s:ReadUrl("<args>")
" }}}

function! s:DiffUrl(url) abort " {{{
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
command! -bar -nargs=1 Rdiff call s:DiffUrl("<args>")
" }}}

function! PromptQuit() abort " {{{
  echo 'Y - kill buffer and current window'
  echo 'y - kill buffer but preserve window'
  echo 'c - kill window but preserve buffer'
  echo 'close current buffer? '
  let l:char = nr2char(getchar())
  if l:char ==# 'Y'
    Sayonara
  elseif l:char ==# 'y'
    execute 'Sayonara!'
  elseif l:char ==? 'c'
    wincmd q
  endif
  silent! redraw!
endfunction
nnoremap <silent> Q :<C-u>call PromptQuit()<CR>
" }}}

function! Togglegjgk() abort " {{{
  " TODO: stop replying on state
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
nnoremap <silent> <Leader>tgj :<C-u>call Togglegjgk()<CR>
" }}}

function! s:GetVisualSelection() abort " {{{
  " http://stackoverflow.com/a/6271254/570760
  let [ l:lnum1, l:col1] = getpos("'<")[1:2]
  let [ l:lnum2, l:col2 ] = getpos("'>")[1:2]
  let l:lines = getline(l:lnum1, l:lnum2)
  let l:lines[-1] = l:lines[-1][: l:col2 - (&selection ==? 'inclusive' ? 1 : 2)]
  let l:lines[0] = l:lines[0][l:col1 - 1:]
  return join(l:lines, "\n")
endfunction
" }}}

function! AdjustWindowHeight(minheight, maxheight) abort " {{{
  exe max([ min([ line('$'), a:maxheight ]), a:minheight ]) . 'wincmd _'
endfunction
" }}}

function! PushBelowOrLeft() abort " {{{
  if winheight(0) / 2 < line('$')
    wincmd H
    vert resize 80
  else
    wincmd J
    call AdjustWindowHeight(1, winheight(0) / 2)
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

function! ExecuteMacroOverVisualRange() abort " {{{
  echo '@'.getcmdline()
  execute ":'<,'>normal @".nr2char(getchar())
endfunction
xnoremap @ :<C-u>call ExecuteMacroOverVisualRange()<CR>
" }}}

function! LessInitFunc() abort " {{{
  setlocal nonumber norelativenumber nolist laststatus=0
  if exists(':AirlineToggle')
    AirlineToggle
  endif
endfunction
" }}}

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction
" }}}
" {{{ autocmds
augroup VIM
  autocmd!

  autocmd FileType rust
  \ set formatprg=rustfmt

  if has('nvim')
    autocmd TermOpen *
    \ setlocal nolist nonu nornu
  endif

  autocmd BufWritePost *tmux.conf
  \ if exists('$TMUX') |
  \   call system('tmux source-file ~/.tmux.conf && tmux display-message "Sourced .tmux.conf"') |
  \ endif

  autocmd FileType javascript
  \ set formatprg=yarn\ --silent\ prettier-eslint\ --stdin

  autocmd BufReadPost *
  \ if &ft != 'gitcommit' && line("'\"") > 0 && line("'\"") <= line('$') |
  \   execute 'normal! g`"zvzz' |
  \ endif

  autocmd FileType markdown,text,liquid
  \ setlocal nocursorline nocursorcolumn |
  \ call textobj#sentence#init()

  autocmd BufEnter *
  \ if &buftype != '' |
  \   setlocal nocursorcolumn nocursorline colorcolumn=0 |
  \   nnoremap <silent><buffer> q :<C-u>bd<CR> |
  \ endif

  au FileType gitcommit
  \ setlocal spell textwidth=72 |
  \ startinsert

  " autocmd InsertLeave * hi CursorLine ctermbg=0
  " autocmd InsertEnter * hi CursorLine ctermbg=7

  autocmd FileType qf
  \ setlocal bufhidden=wipe nobuflisted |
  \ call AdjustWindowHeight(1, winheight(0) / 2)

  autocmd FileType help
  \ wincmd L |
  \ vert resize 80

  autocmd VimResized help
  \ vert resize 10

  autocmd BufEnter *
  \ if &filetype ==? 'help' |
  \   execute 'normal 0' |
  \   vert resize 80 |
  \ endif

  autocmd BufLeave *
  \ if &filetype ==? 'help' |
  \   execute 'normal 0' |
  \   vert resize 10 |
  \ endif

  autocmd BufWritePost *vimrc
  \ source ~/.vimrc |
  \ if exists(':AirlineRefresh') |
  \   AirlineRefresh |
  \ endif
  " \ if exists('*lightline#highlight') |
  " \   call lightline#highlight() |
  " \ endif

  autocmd FileType vim
  \ xnoremap <buffer> <Leader>S y:@"<CR>

  autocmd FileType vim-plug,gundo,diff
  \ setlocal nonu nornu nolist nocursorline nocursorcolumn

  if exists('*termopen')
    autocmd TermOpen *
    \ setlocal nolist nocursorline nocursorcolumn

    autocmd BufEnter *
    \ if &buftype ==? 'terminal' |
    \   startinsert |
    \ endif
  endif

  autocmd FileType json syntax match Comment +\/\/.\+$+

augroup END
" }}}
" {{{ misc commands and maps
" inoremap <expr><Tab> pumvisible() ? "\<C-n>" : "\<TAB>"
" inoremap <expr><S-Tab> pumvisible() ? "\<C-p>" : "\<TAB>"

inoremap <silent><expr> <TAB>
  \ pumvisible() ? "\<C-n>" :
  \ <SID>check_back_space() ? "\<TAB>" :
  \ coc#refresh()
" inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
" inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

nnoremap <Leader>evim :<C-u>vs ~/dotfiles/vimrc<CR>

nnoremap ' `
nnoremap ` '

nnoremap n nzMzvzz
nnoremap N NzMzvzz
nnoremap g, g,zMzvzz
nnoremap <C-Z> <Esc>zMzvzz
nnoremap zk zkzMzvzz
nnoremap zj zjzMzvzz
nnoremap Y y$

nnoremap gV `[v`]

nnoremap <F2> :<C-u>bw<CR>
nnoremap <F5> :<C-u>e %<CR>
nnoremap <F3> <Esc>"=strftime('%c')<Left><Left>
inoremap <F3> <C-R>=strftime('%c')<Left><Left>
nnoremap <F5> :<C-u>e %<CR>
nnoremap <F6> :<C-u>set paste!<CR>
inoremap <F6> <C-O>:set paste!<CR>
nnoremap <leader>t2 :<C-u>set ts=2 sw=2<CR>
nnoremap <leader>t4 :<C-u>set ts=4 sw=4<CR>
nnoremap <leader>t8 :<C-u>set ts=8 sw=8<CR>
nnoremap yoe :<C-u>set expandtab!<CR>
nnoremap <leader>s :<C-u>%s///gc<left><left><left><left>
xnoremap <leader>s *:s///gc<left><left><left>
nnoremap <silent> # #n<esc>:redraw<cr>:s////gc<left><left><left>
" nnoremap <Leader> <Nop>

nnoremap <silent><expr> K (&keywordprg == 'man' && exists('$TMUX')) ? printf(':!tmux split-window -h "man %s"<CR>:redraw<CR>', expand('<cword>')) : 'K'

cabbrev %% <C-R>=fnameescape(expand('%:h'))<CR>

command! -bang Qa qa<bang>
command! -bang Wa wa<bang>
command! -bang Wqa wqa<bang>

if exists(':SudoWrite') > 0
  cabbrev w!! SudoWrite
else
  cabbrev w!! w !sudo tee >/dev/null "%"
endif

"           +--Disable hlsearch while loading viminfo
"           | +--Remember marks for last 500 files
"           | |    +--Remember up to 10000 lines in each register
"           | |    |      +- -Remember up to 1MB in each register
"           | |    |      |     +--Remember last 1000 search patterns
"           | |    |      |     |     +---Remember last 1000 commands
"           | |    |      |     |     |
"           v v    v      v     v     v
set viminfo=h,'500,<10000,s1000,/1000,:1000

let &t_SI = "\<Esc>[5 q"
let &t_EI = "\<Esc>[1 q"

" macros

" extract markdown links into footnotes
" appends footnotes to the bottom, assuming `[1]: ` is the last line
" di)mmG$pyyplWD^klyi]'mPcs)]n

" }}}
