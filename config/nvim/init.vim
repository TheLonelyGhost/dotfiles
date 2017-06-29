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

" Vimwiki settings
let g:work_wiki = {
      \   'path': '~/vimwiki/work/',
      \   'path_html': '~/Documents/work-notes/',
      \   'auto_toc': 1,
      \ }
let g:personal_wiki = {
      \   'path': '~/vimwiki/personal/',
      \   'path_html': '~/Documents/personal-notes/',
      \   'auto_toc': 1,
      \ }
let g:vimwiki_list = [ g:personal_wiki, g:work_wiki ]
let g:vimwiki_html_header_numbering = 2

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

  " When switching between buffers or done inserting, refresh the syntax
  " highlighting so it doesn't get all wonky in big files
  autocmd BufEnter,InsertLeave * :syntax sync fromstart
augroup END

" Status Line
set statusline=%#warningmsg#\ %{ALEGetStatusLine()}\ %* " Left
set statusline+=%=
" '(row,column)'
set statusline+=(%l,%c) " Middle
set statusline+=%=
" (relative) filename, filetype, modified indicator, read-only indicator, preview-only indicator
set statusline+=%f\ %y%m%r%w " Right

" For linting, we'll override Rubocop flags per-project using .exrc
set exrc
let g:ale_lint_delay=600
let g:ale_ruby_rubocop_options='--display-cop-names'

" Disable search match highlight
nnoremap <silent> <leader><space> :silent noh<CR>
" Remove trailing whitespace
nnoremap <silent> <leader>W :silent %s/\s\+$//g<CR>
" Refresh syntax highlighting from insert or normal modes
nnoremap <silent> <C-a> :syntax off<CR>:syntax on<CR>
inoremap <silent> <C-a> <C-o>:syntax off<CR><C-o>:syntax on<CR>

" Tab width = 2 && spaces instead of tabs
set expandtab sts=2 ts=2 sw=2

set background=dark
let g:solarized_termcolors = 256
let g:solarized_visibility = 'high'
let g:solarized_contrast = 'high'
colorscheme solarized
