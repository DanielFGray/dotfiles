" TODO: more comments
filetype plugin indent on
let g:mapleader = "\<Space>"

" {{{ plugins
let s:configdir = '.vim'
if has('nvim')
  let s:configdir = '.config/nvim'
endif

if empty(glob('~/' . s:configdir . '/autoload/plug.vim'))
  silent call system('mkdir -p ~/' . s:configdir . '/{autoload,bundle,cache,undo,backups,swaps}')
  silent call system('curl -fLo ~/' . s:configdir . '/autoload/plug.vim https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim')
  execute 'source  ~/' . s:configdir . '/autoload/plug.vim'
  autocmd VimEnter * PlugInstall
endif

call plug#begin('~/' . s:configdir . '/bundle')

" {{{ text objects
Plug 'wellle/targets.vim'
Plug 'kana/vim-textobj-user'
Plug 'kana/vim-textobj-indent'
Plug 'kana/vim-textobj-function'
Plug 'kentaro/vim-textobj-function-php'
Plug 'thinca/vim-textobj-function-javascript'
Plug 'glts/vim-textobj-comment'
Plug 'reedes/vim-textobj-sentence'
Plug 'thinca/vim-textobj-between'
" }}}

" {{{ operators
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-speeddating'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-repeat'
Plug 'tommcdo/vim-exchange'
Plug 'kana/vim-operator-user'
Plug 'haya14busa/vim-operator-flashy' " {{{
  map y <Plug>(operator-flashy)
  map Y <Plug>(operator-flashy)$
  let g:operator#flashy#group = 'Search'
" }}}
" }}}

" {{{ searching
Plug 'justinmk/vim-sneak' " {{{
  let g:sneak#prompt = '(sneak)» '
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
Plug 'haya14busa/incsearch.vim' " {{{
  let g:incsearch#consistent_n_direction = 1
  let g:incsearch#auto_nohlsearch = 1
  let g:incsearch#magic = '\v'
  map /  <Plug>(incsearch-forward)
  map ?  <Plug>(incsearch-backward)
  map g/ <Plug>(incsearch-stay)
  map n  <Plug>(incsearch-nohl-n)<C-Z>
  map N  <Plug>(incsearch-nohl-N)<C-Z>
  map *  <Plug>(incsearch-nohl-*)
  map #  <Plug>(incsearch-nohl-#)
  map g* <Plug>(incsearch-nohl-g*)
  map g# <Plug>(incsearch-nohl-g#)
" }}}
Plug 'haya14busa/incsearch-fuzzy.vim' " {{{
  map z/ <Plug>(incsearch-fuzzy-/)
  map z? <Plug>(incsearch-fuzzy-?)
  map zg/ <Plug>(incsearch-fuzzy-stay)
" }}}
Plug 'osyo-manga/vim-over' " {{{
  let g:over_command_line_prompt = ':'
  let g:over_enable_cmd_window = 1
  let g:over#command_line#search#enable_incsearch = 1
  let g:over#command_line#search#enable_move_cursor = 1
  nnoremap <silent> <Leader>s <Esc>:OverCommandLine %s///g<CR><Left><Left>
  xnoremap <silent> <Leader>s <Esc>:OverCommandLine '<,'>s///g<CR><Left><Left>
" }}}
Plug 'terryma/vim-multiple-cursors' " {{{
  function! Multiple_cursors_before()
    if exists(':NeoCompleteLock') == 2
      NeoCompleteLock
    endif
    if exists('*SwoopFreezeContext') != 0
        call SwoopFreezeContext()
    endif
  endfunction
  function! Multiple_cursors_after()
    if exists(':NeoCompleteUnlock') == 2
      NeoCompleteUnlock
    endif
    if exists('*SwoopUnFreezeContext') != 0
        call SwoopUnFreezeContext()
    endif
  endfunction
" }}}
Plug 'bronson/vim-visual-star-search'
Plug 'pelodelfuego/vim-swoop' " {{{
  let g:swoopUseDefaultKeyMap = 0
  let g:swoopIgnoreCase = 1
  nnoremap <silent> <Leader>l :call Swoop()<CR>
  vnoremap <silent> <Leader>l :call SwoopSelection()<CR>
  nnoremap <silent> <Leader>ml :call SwoopMulti()<CR>
  vnoremap <silent> <Leader>ml :call SwoopMultiSelection()<CR>
" }}}
if executable('ag')
  set grepprg=ag\ --nogroup\ --column\ --smart-case\ --nocolor\ --follow
  set grepformat=%f:%l:%c:%m
elseif executable('ack')
  set grepprg=ack\ --nogroup\ --column\ --smart-case\ --nocolor\ --follow\ $*
  set grepformat=%f:%l:%c:%m
endif
" }}}

" {{{ completion/building
Plug 'jaawerth/nrun.vim'
if has('nvim')
  Plug 'Shougo/Deoplete.nvim' " {{{
    let g:deoplete#enable_at_startup = 1
    let g:deoplete#auto_completion_start_length = 3
  " }}}
  Plug 'benekastah/neomake' " {{{
    let g:neomake_open_list = 2
  " }}}
  Plug 'kassio/neoterm'
else
  Plug 'Shougo/vimproc' " {{{
  \, {'do': 'make'}
  " }}}
  if has('lua') && (version >= 704 || version == 703 && has('patch885')) " {{{
    Plug 'Shougo/neocomplete.vim'
    let g:completionEngine = 'neocomplete'
  elseif has('lua')
    Plug 'Shougo/neocomplcache.vim'
    let g:completionEngine = 'neocomplcache'
  endif
  if exists('g:completionEngine')
    let g:acp_enableAtStartup = 0
    let g:{g:completionEngine}#enable_at_startup = 1
    let g:{g:completionEngine}#enable_smart_case = 1
    let g:{g:completionEngine}#sources#syntax#min_keyword_length = 3
    let g:{g:completionEngine}#auto_completion_start_length = 3
    let g:{g:completionEngine}#sources#dictionary#dictionaries = { 'default' : '' }
    let g:{g:completionEngine}#sources#omni#input_patterns = {}
    let g:{g:completionEngine}#keyword_patterns = { 'default': '\h\w*' }
    let g:{g:completionEngine}#data_directory = '~/' . s:configdir . '/cache/neocompl'
    inoremap <expr><C-G>     {g:completionEngine}#undo_completion()
    inoremap <expr><C-L>     {g:completionEngine}#complete_common_string()
    inoremap <expr><BS>      {g:completionEngine}#smart_close_popup()."\<C-H>"
    inoremap <expr><Tab>     pumvisible() ? "\<C-N>" : "\<Tab>"
  endif " }}}
  Plug 'scrooloose/syntastic' " {{{
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
    let g:syntastic_javascript_checkers = ['eslint']
    let g:syntastic_css_checkers = ['stylelint']

    nnoremap <silent> <Leader>c <Esc>:SyntasticCheck<CR>
  " }}}
endif
Plug 'Shougo/neosnippet' " {{{
  Plug 'Shougo/neosnippet-snippets'
  let g:neosnippet#snippets_directory = '~/.vim/bundle/vim-snippets/snippets,~/.vim/snippets'
  imap <C-K> <Plug>(neosnippet_expand_or_jump)
  smap <C-K> <Plug>(neosnippet_expand_or_jump)
  xmap <C-K> <Plug>(neosnippet_expand_target)
  imap <expr><tab> neosnippet#expandable_or_jumpable() ?
  \ "\<Plug>(neosnippet_expand_or_jump)"
  \ : pumvisible() ? "\<C-N>" : "\<Tab>"
  smap <expr><tab> neosnippet#expandable_or_jumpable() ?
  \ "\<Plug>(neosnippet_expand_or_jump)" : "\<Tab>"
  if has('conceal')
    set conceallevel=2 concealcursor=i
  endif
" }}}
Plug 'Raimondi/delimitMate' " {{{
  let g:delimitMate_expand_cr = 1
  let g:delimitMate_jump_expansion = 1
" }}}
Plug 'tpope/vim-endwise'
" }}}

" {{{ formatting
Plug 'christoomey/vim-titlecase' " {{{
  let g:titlecase_map_keys = 0
  nmap <Leader>gt <Plug>Titlecase
  vmap <Leader>gt <Plug>Titlecase
  nmap <Leader>gT <Plug>TitlecaseLine
" }}}
Plug 'junegunn/vim-easy-align' " {{{
  nmap <Leader>a <Plug>(LiveEasyAlign)
  vmap <Leader>a <Plug>(LiveEasyAlign)
" }}}
Plug 'reedes/vim-pencil' " {{{
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
Plug 'dahu/Insertlessly' " {{{
  let g:insertlessly_cleanup_trailing_ws = 0
  let g:insertlessly_cleanup_all_ws = 0
  let g:insertlessly_insert_spaces = 0
" }}}
Plug 'editorconfig/editorconfig-vim'
Plug 'tpope/vim-sleuth'
" }}}

" {{{ appearance
Plug 'vim-airline/vim-airline' " {{{
  Plug 'vim-airline/vim-airline-themes'
  let g:airline_theme = 'hybridline'
  let g:airline_powerline_fonts = 1
  let g:airline#extensions#whitespace#enabled = 0
  let g:airline#extensions#branch#enabled = 1
  let g:airline#extensions#tabline#enabled = 1
  let g:airline#extensions#tabline#fnamemod = ':t'
  let g:airline_extensions = [ 'branch', 'tabline', 'nrrwrgn', 'syntastic', 'hunks' ]
  function! AirlineInit()
    let g:airline_section_z = g:airline_section_y
    let g:airline_section_y = g:airline_section_x
    let g:airline_section_x = '%{PencilMode()} %{gutentags#statusline("[Generating ctags...]")}'
  endfunction
  autocmd User AirlineAfterInit call AirlineInit()
" }}}
Plug 'nathanaelkane/vim-indent-guides' " {{{
  let g:indent_guides_start_level = 2
  let g:indent_guides_guide_size = 1
  let g:indent_guides_space_guides = 1
  nmap <silent> <Leader>I <Plug>IndentGuidesToggle
" }}}
Plug 'junegunn/limelight.vim' " {{{
  let g:limelight_conceal_ctermfg = 'black'
" }}}
Plug 'junegunn/goyo.vim' " {{{
  function! s:goyo_enter()
    set showmode
    set scrolloff=999
    if exists('$TMUX')
      silent !tmux set status off
    endif
    augroup Distractions
      autocmd!
      autocmd VimLeavePre * silent! !tmux set -q status on
    augroup END
  endfunction
  function! s:goyo_leave()
    set noshowmode
    set scrolloff=5
    if exists('$TMUX')
      silent !tmux set status on
    endif
    augroup Distractions
      autocmd!
    augroup END
  endfunction
  autocmd! User GoyoEnter nested call <SID>goyo_enter()
  autocmd! User GoyoLeave nested call <SID>goyo_leave()
  nnoremap <Leader>df <Esc>:Goyo<CR>
" }}}
Plug 'mhinz/vim-startify' " {{{
  let g:startify_change_to_vcs_root = 1

  function! s:filter_header(str) abort
    return map(split(system('figlet -f future "'. a:str .'"'), '\n'), '"         ". v:val') + [ '', '' ]
  endfunction

  if has('nvim')
    " let g:startify_custom_header = s:filter_header('NeoVim')
    let g:startify_custom_header = [
    \ '        ┏┓╻┏━╸┏━┓╻ ╻╻┏┳┓',
    \ '        ┃┗┫┣╸ ┃ ┃┃┏┛┃┃┃┃',
    \ '        ╹ ╹┗━╸┗━┛┗┛ ╹╹ ╹',
    \ '' ]
  else
    " let g:startify_custom_header = s:filter_header('Vim')
    let g:startify_custom_header = [
    \ '        ╻ ╻╻┏┳┓',
    \ '        ┃┏┛┃┃┃┃',
    \ '        ┗┛ ╹╹ ╹',
    \ '' ]
  endif
" }}}
Plug 'reedes/vim-thematic' " {{{
  let g:thematic#defaults = {
  \ 'background': 'dark'
  \ }
  let g:thematic#themes = {
  \ 'gui': {
  \   'colorscheme': 'atom-dark-256',
  \   'airline': 'noctu',
  \   'typeface': 'Fantasque Sans Mono',
  \   'font-size': 10,
  \ },
  \ 'term': {
    \ 'colorscheme': 'noctu',
    \ 'airline': 'hybridline'
  \ }
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
Plug 'noahfrederick/vim-noctu'
Plug 'gosukiwi/vim-atom-dark'
Plug 'DanielFGray/DistractionFree.vim'
" }}}

" {{{ prose
Plug 'reedes/vim-litecorrect' " {{{
  augroup litecorrect
    autocmd!
    autocmd FileType markdown,text,liquid
    \ call litecorrect#init()
  augroup END
" }}}
Plug 'reedes/vim-lexical' " {{{
  " curl -L http://www.gutenberg.org/files/3202/files/mthesaur.txt -o ~/.vim/thesaurus/mthesaur.txt --create-dirs
  let g:lexical#dictionary = [ '/usr/share/dict/cracklib-small' ]
  augroup Lexical
    autocmd!
    autocmd FileType markdown,text,liquid
    \ call lexical#init()
  augroup END
" }}}
Plug 'reedes/vim-wordy' " {{{
  augroup Wordy
    autocmd!
    autocmd FileType markdown,text,liquid
    \ nnoremap <buffer> [w <Esc>:PrevWordy<CR>
    autocmd FileType markdown,text,liquid
    \ nnoremap <buffer> ]w <Esc>:NextWordy<CR>
  augroup END
" }}}
" }}}

" {{{ misc/unorganized
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-eunuch'
Plug 'vim-utils/vim-husk'
" Plug 'sjl/gundo.vim' " {{{
"   nnoremap <silent> <Leader>u <Esc>:GundoToggle<CR>
"   let g:gundo_right = 1
"   let g:gundo_width = 80
"   let g:gundo_preview_height = 20
" " }}}
Plug 'chrisbra/NrrwRgn'
Plug 'Shougo/echodoc' " {{{
  let g:echodoc_enable_at_startup = 1
" }}}
Plug 'jeetsukumaran/vim-filebeagle' " {{{
  let g:filebeagle_suppress_keymaps = 1
  map <silent> - <Plug>FileBeagleOpenCurrentBufferDir
" }}}
Plug 'mhinz/vim-sayonara'
Plug 'AndrewRadev/splitjoin.vim'
Plug 'sheerun/vim-polyglot'
Plug 'junegunn/fzf' " {{{
\, { 'dir': '~/.fzf', 'do': './install --all' }
  nnoremap <Leader>F <Esc>:Files<CR>
" }}}
Plug 'junegunn/fzf.vim'
Plug 'chilicuil/vim-sprunge' " {{{
  let g:sprunge_cmd = 'curl -s -n -F "f:1=<-" http://ix.io'
" }}}
Plug 'mbbill/undotree' " {{{
  let g:undotree_WindowLayout = 4
  let g:undotree_SetFocusWhenToggle = 1
  let g:undotree_SplitWidth = 60
  nnoremap <silent> <Leader>u <Esc>:UndotreeToggle<CR>
  function! g:Undotree_CustomMap()
      nmap <buffer> k <plug>UndotreeGoNextState
      nmap <buffer> j <plug>UndotreeGoPreviousState
      nmap <buffer> <Esc> <plug>UndotreeClose
  endfunc
" }}}
Plug 'chilicuil/vim-sprunge' " {{{
  let g:sprunge_cmd = 'curl -s -n -F "f:1=<-" http://ix.io'
" }}}
Plug 'ludovicchabant/vim-gutentags'
Plug 'metakirby5/codi.vim' " {{{
nnoremap <Leader>C <Esc>:Codi!!<CR>
  let g:codi#rightalign = 1
  let g:codi#rightsplit = 0
  let g:codi#aliases =
  \ { 'javascript.jsx': 'javascript'
  \ }
" }}}
" }}}

" {{{ unite.vim
if has('nvim')
Plug 'Shougo/denite.nvim'
else
Plug 'Shougo/unite.vim'
Plug 'Shougo/neoyank.vim'
Plug 'Shougo/unite-help'
Plug 'Shougo/unite-outline'
Plug 'Shougo/unite-session'
Plug 'Shougo/neomru.vim'
Plug 'Shougo/context_filetype.vim'
Plug 'tsukkee/unite-tag'
Plug 'osyo-manga/unite-filetype'
Plug 'thinca/vim-unite-history'
Plug 'kopischke/unite-spell-suggest'
Plug 'moznion/unite-git-conflict.vim'
Plug 'voi/unite-textobj'

" {{{ settings
  let g:unite_data_directory = '~/.vim/cache/unite'
  let g:unite_force_overwrite_statusline = 0
  let g:unite_winheight = 15
  let g:unite_enable_start_insert = 1
  let g:unite_split_rule = 'rightbelow'
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

  nnoremap <silent> <Leader><Leader> <Esc>:Unite -buffer-name=mapping  mapping<CR>
  nnoremap <silent> <Leader>r        <Esc>:Unite -buffer-name=register register<CR>
  nnoremap <silent> <Leader>y        <Esc>:Unite -buffer-name=yank     history/yank<CR>
  nnoremap <silent> <Leader>;        <Esc>:Unite -buffer-name=command  history/command command<CR>
  nnoremap <silent> <Leader>o        <Esc>:Unite -buffer-name=outline  outline<CR>
  nnoremap <silent> <Leader>h        <Esc>:Unite -buffer-name=help     help<CR>
  nnoremap <silent> <Leader>/        <Esc>:Unite -buffer-name=grep     grep<CR>
  nnoremap <silent> <Leader>ta       <Esc>:Unite -buffer-name=tag      tag tag/file<CR>
  nnoremap <silent> <Leader>b        <Esc>:Unite -buffer-name=buffer   buffer neomru/file file file/new<CR>
  nnoremap <silent> <Leader>f        <Esc>:Unite -buffer-name=files    jump_point file_point file neomru/file file/new<CR>
  nnoremap <silent> <Leader>gl       <Esc>:Unite -buffer-name=line     line<CR>
  nnoremap <silent> z=               <Esc>:Unite -buffer-name=spell    spell_suggest<CR>
  nnoremap <silent> <Leader>to       <Esc>:Unite -buffer-name=textobj  textobj<CR>

  augroup Unite
    autocmd!
    autocmd FileType unite call s:unite_my_settings()
  augroup END

  function! s:unite_my_settings() " {{{
    call unite#filters#sorter_default#use([ 'sorter_rank' ])
    call unite#filters#matcher_default#use([ 'matcher_fuzzy' ])
    call unite#set_profile('files', 'context.smartcase', 1)
    call unite#custom#source('line,outline', 'matchers', 'matcher_regexp')
    call unite#custom#source('line,spell_suggest,textobj,help', 'context', {
    \   'no_split': 0,
    \   'split': 1,
    \   'auto_resize': 1,
    \   'winheight': 15
    \ })

    call unite#custom#profile('default', 'context', {
    \   'start_insert': 1,
    \   'prompt_direction': 'top',
    \   'prompt_focus': 1,
    \   'force_redraw': 1,
    \   'no_empty': 1,
    \   'winheight': 100,
    \   'direction': 'dynamicbottom',
    \   'enable_start_insert': 1,
    \   'no_split': 1
    \ })
    " \   'prompt': ' ',

  " imap <buffer>               <Esc> <Plug>(unite_exit)
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

    let unite = unite#get_current_unite()
    if unite.profile_name ==# 'search'
      nnoremap <silent><buffer><expr> r unite#do_action('replace')
    else
      nnoremap <silent><buffer><expr> r unite#do_action('rename')
    endif

    nnoremap <silent><buffer><expr> cd unite#do_action('lcd')
    nnoremap <buffer><expr> S unite#mappings#set_current_sorters( empty(unite#mappings#get_current_sorters()) ? [ 'sorter_reverse' ] : [])

    " Runs "split" action by <C-s>.
    imap <silent><buffer><expr> <C-s> unite#do_action('split')
    imap <silent><buffer><expr> <C-v> unite#do_action('vsplit')
  endfunction
" }}}

" }}}

endif
" }}}

" {{{ git
Plug 'tpope/vim-fugitive' " {{{
  nnoremap <Leader>gs <Esc>:Gstatus<CR><Esc>:call PushBelowOrLeft()<CR><C-L>
  nnoremap <Leader>gd <Esc>:Gdiff<CR>
  nnoremap <Leader>gc <Esc>:Gcommit<CR><Esc>:call PushBelowOrLeft()<CR><C-L>
  nnoremap <Leader>gb <Esc>:Gblame<CR>
  nnoremap <Leader>gp <Esc>:Git push<CR>
  nnoremap <Leader>gu <Esc>:Git pull<CR>
" }}}
Plug 'airblade/vim-gitgutter' " {{{
  let g:gitgutter_map_keys = 0
  nnoremap <silent> [c <Esc>:GitGutterPrevHunk<CR>zMzvzz
  nnoremap <silent> ]c <Esc>:GitGutterNextHunk<CR>zMzvzz
  nnoremap <silent> <Leader>hs <Esc>:GitGutterStageHunk<CR>
  nnoremap <silent> <Leader>hr <Esc>:GitGutterRevertHunk<CR>
  nnoremap <silent> <Leader>hp <Esc>:GitGutterPreviewHunk<CR>
" }}}
Plug 'lambdalisue/vim-gista'
Plug 'lambdalisue/vim-gista-unite' " {{{
  nnoremap <silent> <Leader>gi <Esc>:Unite gista -buffer-name=gista<CR>
" }}}
Plug 'kmnk/vim-unite-giti' " {{{
  nnoremap <silent> <Leader>gg <Esc>:Unite giti -buffer-name=giti<CR>
" }}}
" }}}

" {{{ tmux
Plug 'tmux-plugins/vim-tmux'
Plug 'wellle/tmux-complete.vim'
Plug 'mhinz/vim-tmuxify' " {{{
  let g:tmuxify_map_prefix = '<Leader>m'
  let g:tmuxify_custom_command = 'tmux split-window -d -v -p 25'
  let g:tmuxify_global_maps = 1
  let g:tmuxify_run = {
    \ 'lilypond':   ' for file in %; do; lilypond $file; x-pdf "${file[@]/%%ly/pdf}"; done',
    \ 'tex':        ' for file in %; do; texi2pdf $file; x-pdf "${file[@]/%%tex/pdf}"; done',
    \ 'ruby':       ' ruby %',
    \ 'python':     ' python %',
    \ 'javascript': ' node %'
  \}
" }}}
" }}}

" {{{ latex
Plug 'LaTeX-Box-Team/LaTeX-Box'
Plug 'xuhdev/vim-latex-live-preview'
" }}}

" {{{ html/css
" Plug 'jaxbot/browserlink.vim' " {{{
"   \, {'for': [ 'html', 'javascript', 'css' ]}
" " }}}
Plug 'suan/vim-instant-markdown' " {{{
  \, {'for': 'markdown'}
  let g:instant_markdown_autostart = 0
" }}}
Plug 'mattn/emmet-vim' " {{{
  \, { 'for': [ 'html', 'javascript.jsx' ] }
" }}}
" Plug 'Valloric/MatchTagAlways'
Plug 'tmhedberg/matchit'
Plug 'othree/html5.vim'
Plug 'groenewege/vim-less'
Plug 'hail2u/vim-css3-syntax'
Plug 'digitaltoad/vim-jade'
Plug 'tpope/vim-liquid'
Plug 'tpope/vim-ragtag' " {{{
  let g:ragtag_global_maps = 1
" }}}

" }}}

" {{{ javascript
Plug 'moll/vim-node'
Plug 'elzr/vim-json' " {{{
  let g:vim_json_syntax_conceal = 0
" }}}
Plug 'othree/yajs.vim'
Plug 'othree/javascript-libraries-syntax.vim'
Plug 'othree/jspc.vim'
Plug 'marijnh/tern_for_vim' " {{{
  \, { 'do': 'npm install' }
  let g:tern_show_signature_in_pum = 1
" }}}
" Plug 'walm/jshint.vim'
Plug 'heavenshell/vim-jsdoc' " {{{
  let g:jsdoc_enable_es6 = 1
  augroup JsDoc
    autocmd!
    autocmd FileType javascript
    \ nnoremap <buffer> <Leader>jd <Plug>(jsdoc)
  augroup END
" }}}
Plug 'mxw/vim-jsx'
" Plug 'mtscout6/syntastic-local-eslint.vim'
" }}}

" {{{ haskell
Plug 'lukerandall/haskellmode-vim'
Plug 'raichoo/purescript-vim'
Plug 'eagletmt/ghcmod-vim'
Plug 'ujihisa/neco-ghc'
" }}}

call plug#end()

if exists('*nrun#Which')
  if exists(':SyntasticInfo')
    let g:syntastic_javascript_eslint_exec = nrun#Which('eslint')
    let g:syntastic_css_stylelint_exec = nrun#Which('stylelint')
  elseif exists(':NeoMake')
    let g:neomake_javascript_eslint_exe = nrun#Which('eslint')
    let g:neomake_javascript_enabled_makers = ['eslint']
    let g:neomake_jsx_eslint_exe = nrun#Which('eslint')
    let g:neomake_jsx_enabled_makers = ['eslint']
    let g:neomake_css_eslint_exe = nrun#Which('stylelint')
    let g:neomake_css_enabled_makers = ['stylelint']
  endif
endif

" }}}

" {{{ general settings
" TODO: more organizing
syntax on

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
set noruler rulerformat=%32(%=\:b%n%y%m%r%w\ %l,%c%V\ %P%)
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
set undofile undodir=~/.vim/undo undoreload=10000 undolevels=1000
set backupdir=~/.vim/backups
set directory=~/.vim/swaps

if has('gui_running')
  set guioptions-=LrbTm
endif
" }}}

" {{{ functions

function! PlugAdd() abort " {{{ TODO
  " check clipboard for 'https://github.com/' or user arg
  " substitute above match with 'Plug '
  " surround remainder with quotes
  " add to current line
endfunction
command! -nargs=* PlugAdd call PlugAdd()
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
  if l:diff == ''
    echo 'no changes'
    return 0
  endif
  new | 0put =l:diff
  if empty(getline('$'))
    execute 'normal! Gddgg'
  endif
  call PushBelowOrLeft()
  nnoremap <silent><buffer> q <Esc>:q<CR>
  nnoremap <silent><buffer> <Esc> <Esc>:q<CR>
  setlocal bt=nofile bh=wipe nomod nobl noswf ro foldmethod=diff ft=diff
  return 1
endfunction
command! -bar -nargs=0 DiffU call s:DiffU()
nnoremap <silent> <Leader>d <Esc>:DiffU<CR>
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
nnoremap <silent> <Leader>w <Esc>:W<CR>
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
  let newft = input('filetype? ')
  if strlen(newft) > 0
    execute 'set filetype=' . newft
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
  let l:difft = &ft
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
  let char = nr2char(getchar())
  if char ==# 'Y'
    Sayonara
  elseif char ==# 'y'
    execute 'Sayonara!'
  elseif char ==? 'c'
    wincmd q
  endif
  silent! redraw!
endfunction
nnoremap <silent> Q <Esc>:call PromptQuit()<CR>
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
nnoremap <silent> <Leader>tgj <Esc>:call Togglegjgk()<CR>
" }}}

function! s:GetVisualSelection() abort " {{{
  " http://stackoverflow.com/a/6271254/570760
  let [ lnum1, col1] = getpos("'<")[1:2]
  let [ lnum2, col2 ] = getpos("'>")[1:2]
  let lines = getline(lnum1, lnum2)
  let lines[-1] = lines[-1][: col2 - (&selection ==? 'inclusive' ? 1 : 2)]
  let lines[0] = lines[0][col1 - 1:]
  return join(lines, "\n")
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
  let line = getline(v:foldstart)
  let nucolwidth = &fdc + &number * &numberwidth
  let windowwidth = winwidth(0) - nucolwidth - 3
  let foldedlinecount = v:foldend - v:foldstart
  let onetab = strpart('          ', 0, &tabstop)
  let line = substitute(line, '\t', onetab, 'g')
  let line = strpart(line, 0, windowwidth - 2 - len(foldedlinecount))
  let fillcharcount = windowwidth - len(line) - len(foldedlinecount) - 2
  return line . ' ' . repeat(' ', fillcharcount)  . ' '. foldedlinecount
endfunction
" }}}

function! ExecuteMacroOverVisualRange() abort " {{{
  echo '@'.getcmdline()
  execute ":'<,'>normal @".nr2char(getchar())
endfunction
xnoremap @ :<C-u>call ExecuteMacroOverVisualRange()<CR>
" }}}

function! LessInitFunc() abort " {{{
  setlocal nonu nornu nolist laststatus=0
  if exists(':AirlineToggle')
    AirlineToggle
  endif
endfunction
" }}}

" }}}

" {{{ autocmds
augroup VIM
  autocmd!

  autocmd BufWritePost *tmux.conf
  \ if exists('$TMUX') |
  \   call system('tmux source-file ~/.tmux.conf && tmux display-message "Sourced .tmux.conf"') |
  \ endif

  " autocmd BufRead,BufNewFile *.es6
  " \ setfiletype javascript

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
  \   nnoremap <silent><buffer> q <Esc>:bd<CR> |
  \ endif

  au FileType gitcommit
  \ setlocal spell textwidth=72 |
  \ startinsert

  " autocmd InsertLeave * hi CursorLine ctermbg=0
  " autocmd InsertEnter * hi CursorLine ctermbg=7

  autocmd FileType qf
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

  autocmd FileType vim
  \ nnoremap <buffer> K <Esc>:UniteWithCursorWord -buffer-name=help -split -direction=botright -winheight=15 -auto-resize help<CR>
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

augroup END
" }}}

" {{{ misc commands and maps
nnoremap <Leader>evim <Esc>:vs ~/dotfiles/vimrc<CR>

nnoremap ' `
nnoremap ` '

nnoremap g; g;zvzz
nnoremap g, g,zvzz
nnoremap <C-Z> <Esc>zMzvzz

nnoremap gV `[v`]

nnoremap <F6> <Esc>:set paste!<CR>
inoremap <F6> <C-O>:set paste!<CR>

nnoremap <Leader> <Nop>

nnoremap <silent><expr> K (&keywordprg == 'man -s' && exists('$TMUX')) ? printf(':!tmux split-window -h "man %s"<CR>:redraw<CR>', expand('<cword>')) : 'K'

cabbrev %% <C-R>=fnameescape(expand('%:h'))<CR>

command! -bang Qa qa<bang>
command! -bang Wa wa<bang>
command! -bang Wqa wqa<bang>

if exists(':SudoWrite')
  cabbrev w!! SudoWrite
else
  cabbrev w!! w !sudo tee >/dev/null "%"
endif

highlight diffAdded ctermfg=darkgreen
highlight diffRemoved ctermfg=darkred
highlight Folded ctermfg=14

"           +--Disable hlsearch while loading viminfo
"           | +--Remember marks for last 500 files
"           | |    +--Remember up to 10000 lines in each register
"           | |    |      +--Remember up to 1MB in each register
"           | |    |      |     +--Remember last 1000 search patterns
"           | |    |      |     |     +---Remember last 1000 commands
"           | |    |      |     |     |
"           v v    v      v     v     v
set viminfo=h,'500,<10000,s1000,/1000,:1000

" FIXME: Use a blinking upright bar cursor in Insert mode, a blinking block in normal
if exists('$TMUX')
  let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
  let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
elseif &term == 'xterm-256color' || &term == 'screen-256color'
  let &t_SI = "\<Esc>[5 q"
  let &t_EI = "\<Esc>[2 q"
endif
" }}}
