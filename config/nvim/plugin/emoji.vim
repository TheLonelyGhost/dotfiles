nnoremap <Leader><Bslash> :s/:\([^:]\+\):/\=emoji#for(submatch(1), submatch(0))/g<CR>:noh<CR>
