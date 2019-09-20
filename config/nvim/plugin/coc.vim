" Diagnostic messages are painful when it's set to the default value of 4000
set updatetime=300

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1] =~# '\s'
endfunction

if exists('pumvisible') && exists('check_back_space')
  " Use tab to trigger completion with characters ahead and navigate.
  " Use command ':verbose imap <tab>' to make sure tab is not mapped by other
  " plugins.
  inoremap <silent><expr> <TAB>
        \ pumvisible() ? "\<C-n>" :
        \ <SID>check_back_space() ? "\<TAB>" :
        \ coc#refresh()
  inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
endif

if exists('coc#refresh')
  " Use Ctrl-\ to trigger completion
  inoremap <silent><expr> <C-\> coc#refresh()
endif

if exists('pumvisible')
  " Use <CR> to confirm completion, `<C-g>u` means break undo chain at current
  " position. Coc only does snippet and additional edit to confirm.
  inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
endif

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

if exists('show_documentation')
  " Use K to show documentation
  nnoremap <silent> K :call <SID>show_documentation()<CR>
endif

" Remap keys for gotos
nnoremap <silent> gd <Plug>(coc-definition)
nnoremap <silent> gy <Plug>(coc-type-definition)
nnoremap <silent> gi <Plug>(coc-implementation)
nnoremap <silent> gr <Plug>(coc-references)
