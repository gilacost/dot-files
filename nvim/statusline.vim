let g:airline_theme='grubvox'
let g:airline#extensions#ale#enabled = 1

" Don't display encoding unless it is unexpected
let g:airline#parts#ffenc#skip_expected_string='utf-8[unix]'

" Use abbreviations to display modes
let g:airline_mode_map = {
      \ '__' : '-',
      \ 'n'  : 'N',
      \ 'i'  : 'I',
      \ 'R'  : 'R',
      \ 'c'  : 'C',
      \ 'v'  : 'V',
      \ 'V'  : 'V',
      \ '' : 'V',
      \ 's'  : 'S',
      \ 'S'  : 'S',
      \ '' : 'S',
      \ }

" Disable showing hunks
let g:airline#extensions#hunks#enabled = 0

function! MyAirline()
  let g:airline_section_z = airline#section#create(['linenr', 'maxlinenr'])
endfunction
autocmd User AirlineAfterInit call MyAirline()
