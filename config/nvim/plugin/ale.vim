
let g:ale_lint_delay=600

let g:ale_ruby_rubocop_options='--display-cop-names'

" This should probably be set on a buffer-by-buffer basis:
" let g:ale_echo_msg_format = '[%linter%|%severity%] %s'

let g:ale_dockerfile_hadolint_use_docker = 'always'

" Defer to deoplete instead of this:
" let g:ale_completion_enabled = 1
