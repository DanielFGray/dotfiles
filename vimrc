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
  nnoremap <silent> <leader>      :<c-u>WhichKey '<Space>'<CR>
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
Plug 'https://github.com/jeetsukumaran/vim-filebeagle' " {{{ " simple file navigator
  let g:filebeagle_suppress_keymaps = 1
  map <silent> - <Plug>FileBeagleOpenCurrentBufferDir
" }}}
Plug 'https://github.com/chilicuil/vim-sprunge' " {{{      " quick paste to sprunge
  nnoremap <leader>pa <Plug>Sprunge
  xnoremap <leader>pa <Plug>Sprunge
  " let g:sprunge_cmd = 'curl -s -n -F "f:1=<-" http://ix.io'
" }}}
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
  map *  <Plug>(asterisk-*)
  map g* <Plug>(asterisk-g*)
  map #  <Plug>(asterisk-#)
  map g# <Plug>(asterisk-g#)
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
Plug 'https://github.com/junegunn/fzf.vim' " {{{           " fzf commands `:Files :Maps`
  nnoremap <silent> <leader><leader> :<C-u>Maps<CR>
  nnoremap <silent> <leader>f :<C-u>Files<CR>
  nnoremap <silent> <leader>b :<C-u>Buffers<CR>
  nnoremap <silent> <leader>; :<C-u>Commands<CR>
  if executable('rg')
    nnoremap <leader>gr :<C-u>Rg<Space>
  elseif executable('ag')
    nnoremap <leader>gr :<C-u>Ag<Space>
  endif
" }}}
" }}}
" {{{ appearance
Plug 'https://github.com/kyazdani42/nvim-web-devicons' " for file icons
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
Plug 'https://github.com/lukas-reineke/indent-blankline.nvim' " {{{        " visual indent rules
  let g:indent_blankline_char_list = ['│', '¦', '┆', '┊']
  let g:indent_blankline_show_first_indent_level = 1
  let g:indent_blankline_use_treesitter = 1
  let g:indent_blankline_filetype_exclude = [
  \ 'help',
  \ 'startify',
  \ 'terminal'
  \ ]
" }}}
Plug 'https://github.com/noahfrederick/vim-noctu'          " a simple terminal based theme
Plug 'https://github.com/flazz/vim-colorschemes'           " color scheme bundle
Plug 'https://github.com/nvim-treesitter/nvim-treesitter'  " {{{ better syntax highlighting
\ , {'do': ':TSUpdate'}
" }}}
Plug 'https://github.com/danielfgray/distractionfree.vim' "{{{
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
Plug 'https://github.com/neoclide/coc.nvim' " {{{          " lsp completions
\ , {'branch': 'master', 'do': 'yarn install --frozen-lockfile'}

  let g:coc_global_extensions = [
  \ 'coc-css',
  \ 'coc-diagnostic',
  \ 'coc-docker',
  \ 'coc-emmet',
  \ 'coc-eslint',
  \ 'coc-import-cost',
  \ 'coc-json',
  \ 'coc-lists',
  \ 'coc-lua',
  \ 'coc-marketplace',
  \ 'coc-prettier',
  \ 'coc-python',
  \ 'coc-rls',
  \ 'coc-sh',
  \ 'coc-snippets',
  \ 'coc-stylelintplus',
  \ 'coc-tsserver',
  \ 'coc-vimlsp',
  \ 'coc-yaml'
  \ ]

  function! s:show_documentation()
    if (index(['vim','help'], &filetype) >= 0)
      execute 'h '.expand('<cword>')
    elseif (coc#rpc#ready())
      call CocActionAsync('doHover')
    elseif (&filetype == 'sh')
      execute '!' . &keywordprg . " " . expand('<cword>')
    endif
  endfunction

  function! s:coc_hover() abort
    call CocActionAsync('highlight')
    " if CocAction('hasProvider', 'hover')
    "   call CocActionAsync('doHover')
    " endif
  endfunction

  inoremap <silent><expr> <c-space> coc#refresh()
  " Use `[c` and `]c` for navigate diagnostics
  nmap <silent> [c <Plug>(coc-diagnostic-prev)
  nmap <silent> ]c <Plug>(coc-diagnostic-next)

  " Remap keys for gotos
  nmap <silent> gd <Plug>(coc-definition)
  nmap <silent> gy <Plug>(coc-type-definition)
  nmap <silent> gi <Plug>(coc-implementation)
  nmap <silent> gr <Plug>(coc-references)
  " Search workspace symbols
  nmap <silent> gO :<C-u>CocList outline<CR>

  " Use gK for show documentation in preview window
  nnoremap <silent> gK :call <SID>show_documentation()<CR>

  " xmap <silent> <C-n> <Plug>(coc-cursors-range)
  " nmap <silent> <C-n> <Plug>(coc-cursors-word)

  " Remap for rename current word
  nmap <leader>rn <Plug>(coc-rename)

  " Remap for do codeAction of selected region
  nmap <leader>ac <Plug>(coc-codeaction-cursor)
  xmap <leader>ac <Plug>(coc-codeaction-selected)

  " Remap for do codeAction of current line
  nmap <leader>cc <Plug>(coc-codeaction-line)
  " Fix autofix problem of current line
  nmap <leader>qf <Plug>(coc-fix-current)

  " Show all diagnostics
  nnoremap <silent> <leader>d :<C-u>CocList diagnostics<CR>
  " Manage extensions
  nnoremap <silent> <leader>ce :<C-u>CocList extensions<CR>

  " Show commands
  nnoremap <silent> <leader>co :<C-u>CocList commands<CR>
  nnoremap <silent> <leader>rg :<C-u>CocList registers<CR>

  xnoremap <leader>= <Plug>(coc-format-selected)
  nnoremap <leader>= <Plug>(coc-format-selected)

  " Use `:Format` for format current buffer
  command! -nargs=0 Format :call CocAction('format')

  " Use `:Fold` for fold current buffer
  command! -nargs=? Fold :call CocAction('fold', <f-args>)

  " overload tab with jump
  inoremap <silent><expr> <TAB> pumvisible()
    \ ? coc#_select_confirm()
    \ : coc#expandableOrJumpable()
    \ ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>"
    \ : coc#refresh()
  inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

  " Use <c-space> to trigger completion.
  if has('nvim')
    inoremap <silent><expr> <c-space> coc#refresh()
  else
    inoremap <silent><expr> <c-@> coc#refresh()
  endif

  " Make <CR> auto-select the first completion item and notify coc.nvim to
  " format on enter, <CR> could be remapped by other vim plugin
  inoremap <silent><expr> <CR>pumvisible()
  \ ? coc#_select_confirm()
  \ : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

  nmap <expr> <silent> <C-n> <SID>select_current_word()
  function! s:select_current_word()
    if !get(b:, 'coc_cursors_activated', 0)
      return "\<Plug>(coc-cursors-word)"
    endif
    return "*\<Plug>(coc-cursors-word):nohlsearch\<CR>"
  endfunc

  augroup Coc
    autocmd!
    autocmd FileType rust,javascript,typescript,typescriptreact,javascriptreact,json,css,html
    \ setl formatexpr=CocAction('formatSelected')
    autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
    autocmd CursorHold * silent call s:coc_hover()
  augroup END
" }}}
Plug 'https://github.com/mattn/emmet-vim' " {{{            " shorthand for html expansions
  \, { 'for': [ 'html', 'javascript.jsx', 'typescriptreact' ] }
  let g:user_emmet_settings = {
  \   'javascript.jsx' : {
  \       'extends' : 'jsx',
  \   },
  \ }
  " }}}
Plug 'https://github.com/sheerun/vim-polyglot'             " language highlighting/indent bundle
Plug 'https://github.com/martingms/vipsql'                 " dispatch sql commands
Plug 'https://github.com/benjie/pgsql.vim' " {{{           " better postgres highlighting
let g:sql_type_default = 'pgsql'
" }}}
Plug 'https://github.com/samuelsimoes/vim-jsx-utils' " {{{ " jsx helper utils
  augroup JSXutils
    au!
    autocmd FileType typescriptreact,javascript.jsx
    \ nnoremap <leader>ja :call JSXEncloseReturn()<CR>
    autocmd FileType typescriptreact,javascript.jsx
    \ nnoremap <leader>ji :call JSXEachAttributeInLine()<CR>
    autocmd FileType typescriptreact,javascript.jsx
    \ nnoremap <leader>je :call JSXExtractPartialPrompt()<CR>
    autocmd FileType typescriptreact,javascript.jsx
    \ nnoremap <leader>jc :call JSXChangeTagPrompt()<CR>
    autocmd FileType typescriptreact,javascript.jsx
    \ xnoremap <silent> at :call JSXSelectTag()<CR>
  augroup END
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
Plug 'https://github.com/github/copilot.vim'
" }}}
" {{{ graveyard
" Plug 'https://github.com/vim-airline/vim-airline' " {{{
"   Plug 'https://github.com/vim-airline/vim-airline-themes'
"   let g:airline_theme = 'hybridline'
"   let g:airline_powerline_fonts = 1
"   let g:airline#extensions#branch#enabled = 1
"   let g:airline#extensions#tabline#enabled = 1
"   let g:airline#extensions#tabline#fnamemod = ':t'
"   let g:airline#extensions#whitespace#enabled = 0
"   let g:airline#extensions#wordcount#enabled = 0
"   let g:airline_skip_empty_sections = 1
"   let g:airline_mode_map =
"   \ { '__' : '-'
"   \ , 'n'  : 'N'
"   \ , 'i'  : 'I'
"   \ , 'R'  : 'R'
"   \ , 'c'  : 'C'
"   \ , 'v'  : 'V'
"   \ , 'V'  : 'V'
"   \ , '' : 'V'
"   \ , 's'  : 'S'
"   \ , 'S'  : 'S'
"   \ , '' : 'S'
"   \ }
"   let g:airline#extensions#default#layout =
"   \ [ [ 'a', 'b', 'c' ]
"   \ , [ 'x', 'y', 'error', 'warning' ]
"   \ ]
"   " let g:airline_extensions = [ 'branch', 'tabline', 'hunks', 'coc' ]
"   " function! AirlineInit() abort
"   "   let g:airline_section_z = g:airline_section_y
"   "   let g:airline_section_y = g:airline_section_x
"   "   " let g:airline_section_x = '%{PencilMode()} %{gutentags#statusline("[Generating ctags...]")}'
"   "   let g:airline_section_z = '%{PencilMode()} '
"   " endfunction
"   " augroup Airline
"   "   autocmd!
"   "   autocmd User AirlinieAfterInit call AirlineInit()
"   " augroup END
" " }}}
" Plug 'https://github.com/liuchengxu/eleline.vim' " {{{
"   let g:eleline_slim = 0
" " }}}
" Plug 'https://github.com/ap/vim-buftabline' " {{{          " buffer listing in tabline
"   let g:buftabline_separators = 1
" " }}}
" Plug 'https://github.com/akinsho/nvim-bufferline.lua'
" Plug 'https://github.com/glepnir/galaxyline.nvim'
" Plug 'https://github.com/glepnir/spaceline.vim' " {{{
"   let g:spaceline_seperate_style = 'arrow'
"   let g:spaceline_seperate_style = 'slant'
" " }}}
" }}}
call plug#end()
" }}}
" {{{ general settings
set mouse=nv                                               " mouse on for normal,visual mode (but not insert while typing)
set hidden                                                 " switch buffers without saving
set backspace=indent,eol,start                             " backspace over everything
set foldmethod=marker foldopen-=block                      " fold by markers
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
set list listchars=tab:\|\ ,trail:★                        " visible tab chars and trailing spaces
set listchars+=extends:»,precedes:«                        " custom line wrap chars
" set listchars+=eol:¬,space:🞄                               " visible space and eol chars (very noisy)
set undofile undoreload=10000 undolevels=1000              " store 10kb of 1000 levels of undofile
set undodir=~/.vim/undo//                                  " undofiles in config dir
set backupdir=~/.vim/backups//                             " backups too
set directory=~/.vim/swaps//                               " the trailing slashes are important
set updatetime=300                                         " debounce swap file writing for 1000ms
set showtabline=2                                          " always show tabline

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
" {{{ custom commands and maps
" insert timestamp with ctrl-t
inoremap <C-t> <C-R>=strftime('%c')<Left><Left>
cnoremap <C-t> <C-R>=strftime('%c')<Left><Left>

" make Y behave like C and D
nnoremap Y y$

" swap ` and ' since they are similar, but ' is closer to home-row and ignores mark column
nnoremap ' `
nnoremap ` '

" " open netrw split with -
" nnoremap <silent> - :<C-u>Lex<CR>

" an attempt at exclusive folds
nnoremap zj zjzMzvzz
nnoremap zk zkzMzvzz
nnoremap za zazMzvzz

" expand %% in the command prompt to the current dir
cabbrev %% <C-R>=fnameescape(expand('%:h'))<CR>

" sudo write with :w!! " FIXME this doesn't work in nvim
cabbrev w!! w !sudo tee >/dev/null "%"

" quicker :s mappings with \very magic regex
" see also :h c_CTRL-R_CTRL-W
nnoremap <leader>s :<C-u>s/\v//gc<left><left><left><left>
nnoremap <leader>S :<C-u>%s/\v//gc<left><left><left><left>
xnoremap <leader>s :<C-u>'<'>s/\v//gc<left><left><left>

nnoremap <leader>r :<C-u>s/<C-r><C-w>//gc<left><left><left>
nnoremap <leader>R :<C-u>s/<C-r><C-A>//gc<left><left><left>

" common command typos
command! -bang Qa qa<bang>
command! -bang Wa wa<bang>
command! -bang Wqa wqa<bang>

" common typing mistakes
iabbrev functino function
iabbrev teh the
iabbrev seperate separate
iabbrev frmo from
" }}}
" {{{ functions
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
nnoremap <silent> <Leader>w :<C-u>W<CR>
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

function! Togglegjgk() abort " {{{
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
" }}}
" {{{ autocmds
augroup Vim
  " always wrap autocmds in an augroup
  " reset the augroup so autocmds don't stack on reload
  autocmd!

  " reload vimrc on save (and refresh airline)
  autocmd BufWritePost ~/.vimrc
  \ source ~/.vimrc |
  \ if exists('*lightline#enable()') |
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

  " " use Q to close netrw
  " autocmd FileType netrw
  " \ setl bufhidden=delete |
  " \ wincmd H | vert resize 40 |
  " \ nnoremap <silent><buffer> Q :<C-u>bw<CR><esc>

  " " close netrw when loses focus
  " autocmd WinLeave *
  " \ if getbufvar(winbufnr(winnr()), "&filetype") == "netrw" |
  " \   bw |
  " \ endif

  " open :help to the right at 80 columns
  autocmd FileType help
  \ wincmd L |
  \ vert resize 81

  " expand help when focused
  autocmd BufEnter *
  \ if &filetype ==? 'help' |
  \   execute 'normal 0' |
  \   vert resize 81 |
  \ endif

  " make help small when unfocus
  autocmd BufLeave *
  \ if &filetype ==? 'help' |
  \   execute 'normal 0' |
  \   vert resize 10 |
  \ endif

  " make help small when vim resized
  autocmd VimResized help
  \ vert resize 10

  autocmd TermOpen *
  \ setlocal nonu nornu signcolumn=no

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
