let g:airline#themes#dan#palette = {}

function! s:generate()
  let s:file = airline#themes#get_highlight('Constant')

  let s:N1 = airline#themes#get_highlight2(['PmenuSel', 'fg'], ['User3', 'bg'])
  let s:N2 = airline#themes#get_highlight('Pmenu')
  let s:N3 = airline#themes#get_highlight('CursorLine')
  let g:airline#themes#dan#palette.normal = airline#themes#generate_color_map(s:N1, s:N2, s:N3, s:file)

  let group = airline#themes#get_highlight('vimCommand')
  let g:airline#themes#dan#palette.normal_modified = {
        \ 'airline_c': [ group[0], '', group[2], '', '' ]
        \ }

  let s:I1 = airline#themes#get_highlight2(['PmenuSel', 'fg'], ['Function', 'fg'])
  let s:I2 = airline#themes#get_highlight('Pmenu')
  let s:I3 = s:N3
  let g:airline#themes#dan#palette.insert = airline#themes#generate_color_map(s:I1, s:I2, s:I3, s:file)
  let g:airline#themes#dan#palette.insert_modified = g:airline#themes#dan#palette.normal_modified

  let s:R1 = airline#themes#get_highlight('Error', 'bold')
  let s:R2 = s:N2
  let s:R3 = s:N3
  let g:airline#themes#dan#palette.replace = airline#themes#generate_color_map(s:R1, s:R2, s:R3, s:file)
  let g:airline#themes#dan#palette.replace_modified = g:airline#themes#dan#palette.normal_modified

  let s:V1 = airline#themes#get_highlight2(['PmenuSel', 'fg'], ['SpellBad', 'fg'])
  let s:V2 = airline#themes#get_highlight('Pmenu')
  let s:V3 = s:N3
  let g:airline#themes#dan#palette.visual = airline#themes#generate_color_map(s:V1, s:V2, s:V3, s:file)
  let g:airline#themes#dan#palette.visual_modified = g:airline#themes#dan#palette.normal_modified

  let s:IA = airline#themes#get_highlight2(['NonText', 'fg'], ['CursorLine', 'bg'])
  let g:airline#themes#dan#palette.inactive = airline#themes#generate_color_map(s:IA, s:IA, s:IA, s:file)
  let g:airline#themes#dan#palette.inactive_modified = {
        \ 'airline_c': [ group[0], '', group[2], '', '' ]
        \ }
endfunction

call s:generate()
augroup airline_dan
  autocmd!
  autocmd ColorScheme * call <sid>generate() | call airline#load_theme()
augroup END
