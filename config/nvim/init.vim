let mapleader=' '

" Don't litter the filesystem with vim artifacts
set nobackup
set nowritebackup
set noswapfile

set history=50

" Init Plugins
if filereadable(expand('~/.config/nvim/bundles.vim'))
  source ~/.config/nvim/bundles.vim
endif

