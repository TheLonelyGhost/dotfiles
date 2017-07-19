" -- Key bindings --
nnoremap <silent> <Leader>tt :VimwikiToggleListItem<CR>
nnoremap <silent> <Leader>xp :VimwikiAll2HTML<CR>:e<CR>

" --- Navigation ---
nnoremap <silent> <Leader>sl :VimwikiSplitLink<CR>
nnoremap <silent> <Leader>vl :VimwikiVSplitLink<CR>

" --- Indenting ---
" DEFAULT KEY -> 'gll': [g]o [l]ist [l]ower level
" DEFAULT KEY -> 'gLl': [g]o full[L]ist [l]ower level
" DEFAULT KEY -> 'glh': [g]o [l]ist [h]igher level
" DEFAULT KEY -> 'gLh': [g]o full[L]ist [h]igher level

" -- Settings --
set foldlevel=1
