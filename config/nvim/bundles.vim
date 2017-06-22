" Begin plugin definitions
call plug#begin('~/.local/share/nvim/plugged')

Plug 'editorconfig/editorconfig-vim'
Plug 'vimwiki/vimwiki'
Plug 'w0rp/ale'
Plug 'sheerun/vim-polyglot'
Plug 'PProvost/vim-ps1', { 'for': ['ps1', 'psm1'] }
Plug 'altercation/vim-colors-solarized'

" Initialize plugins
call plug#end()
