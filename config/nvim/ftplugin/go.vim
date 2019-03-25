set tabstop=4 softtabstop=4 shiftwidth=4 noexpandtab

" set makeprg=go\ test\ -v

" nnoremap <leader>t :lmake ./%:h<CR>
nnoremap <leader>t :GoTest<CR>

let b:ale_linters = ['gometalinter']
