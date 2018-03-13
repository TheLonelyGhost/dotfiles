let &binary=1
silent exe '%!xxd'

autocmd BufWritePre <buffer> silent exe '%!xxd -r'
autocmd BufWritePost <buffer> silent exe '%!xxd' | set nomod
