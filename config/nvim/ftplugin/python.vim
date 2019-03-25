nnoremap <silent> <Leader>E :Errors<CR>
nnoremap <silent> <Leader>n :lnext<CR>
nnoremap <silent> <Leader>p :lprevious<CR>

set expandtab ts=4 sts=4 sw=4

let b:ale_linters = ['flake8', 'mypy']
let b:ale_fixers = ['isort', 'remove_trailing_lines', 'trim_whitespace']
