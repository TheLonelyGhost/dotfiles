let mapleader=' '

" Don't litter the filesystem with vim artifacts
set nobackup
set nowritebackup
set noswapfile
set nu

set history=50

" Init Plugins
if filereadable(expand('~/.config/nvim/bundles.vim'))
  source ~/.config/nvim/bundles.vim
endif


nnoremap <silent> <c-h> <c-w>h
nnoremap <silent> <c-j> <c-w>j
nnoremap <silent> <c-k> <c-w>k
nnoremap <silent> <c-l> <c-w>l

set sts=2 ts=2 sw=2
