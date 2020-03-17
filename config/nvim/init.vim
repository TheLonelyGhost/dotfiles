let g:mapleader=' '

" Don't litter the filesystem with vim artifacts
set nobackup
set nowritebackup
set noswapfile
set number

set history=50

nnoremap <silent> <c-h> <c-w>h
nnoremap <silent> <c-j> <c-w>j
nnoremap <silent> <c-k> <c-w>k
nnoremap <silent> <c-l> <c-w>l
inoremap <silent> <c-h> <c-w>h
inoremap <silent> <c-j> <c-w>j
inoremap <silent> <c-k> <c-w>k
inoremap <silent> <c-l> <c-w>l
vnoremap <silent> <c-h> <c-w>h
vnoremap <silent> <c-j> <c-w>j
vnoremap <silent> <c-k> <c-w>k
vnoremap <silent> <c-l> <c-w>l

" Init Plugins
if filereadable(expand('~/.config/nvim/bundles.vim'))
  source ~/.config/nvim/bundles.vim
endif

augroup vimrcEx
  autocmd!

  " When editing a file, always jump to the last known cursor position.
  " Don't do it for commit messages, when the position is invalid, or when
  " inside an event handler (happens when dropping a file on gvim).
  autocmd BufReadPost *
        \ if &ft != 'gitcommit' && line("'\"") > 0 && line("'\"") <= line("$") |
        \   exe "normal g`\"" |
        \ endif

  if filereadable(expand('~/.config/nvim/filetype_aliases.vim'))
    source ~/.config/nvim/filetype_aliases.vim
  endif

  " Hack because ftplugin/bin.vim doesn't set syntax properly
  autocmd FileType bin set syntax=xxd

  " When switching between buffers or done inserting, refresh the syntax
  " highlighting so it doesn't get all wonky in big files
  autocmd BufEnter,InsertLeave * :syntax sync fromstart
augroup END

augroup jsonc
  autocmd!

  " Evaluate it as JSONc
  autocmd FileType json syntax match Comment +\/\/.\+$+
augroup END

let g:ale_lint_delay=600
let g:ale_fix_on_save = 1
let g:ale_ruby_rubocop_options='--display-cop-names'
let g:ale_echo_msg_format = '[%linter%|%severity%] %s'

" Disable search match highlight
nnoremap <silent> <leader><space> :silent noh<CR>
" Remove trailing whitespace
nnoremap <silent> <leader>W :silent %s/\s\+$//g<CR>
" Refresh syntax highlighting from insert or normal modes
nnoremap <silent> <C-a> :syntax off<CR>:syntax on<CR>
inoremap <silent> <C-a> <C-o>:syntax off<CR><C-o>:syntax on<CR>
" Open all folds
nnoremap <silent> <Leader>O :%foldopen!<CR>


" Tab width = 2 && spaces instead of tabs
set expandtab sts=2 ts=2 sw=2

" For linting, we'll override linting settings per-project using .nvimrc
if exists('$EXTRA_VIM')
  " vint: -ProhibitImplicitScopeVariable
  for pathname in split($EXTRA_VIM, ':')
    exec 'source '.pathname
  endfor
  " vint: +ProhibitImplicitScopeVariable
endif

set background=dark
let g:solarized_termcolors = 256
let g:solarized_visibility = 'high'
let g:solarized_contrast = 'high'
colorscheme solarized
highlight Normal ctermbg=NONE
