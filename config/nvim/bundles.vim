" Begin plugin definitions
call plug#begin('~/.local/share/nvim/plugged')

Plug 'sheerun/vim-polyglot'
Plug 'editorconfig/editorconfig-vim'

" Plug 'dense-analysis/ale'
" Plug 'Shougo/deoplete.nvim', {'do': ':UpdateRemotePlugins'}

" Plug 'junegunn/vim-emoji'

Plug 'neovim/nvim-lspconfig' | Plug 'nvim-lua/lsp-status.nvim' | Plug 'nvim-lua/completion-nvim'

Plug 'altercation/vim-colors-solarized'
Plug 'airblade/vim-gitgutter'
Plug 'thelonelyghost/vim-inspec'

" Because vim-polyglot and vim-go fight:
if exists('g:loaded_polyglot')
  if !exists('g:polyglot_disabled')
    let g:polyglot_disabled = []
  end
  if (index(g:polyglot_disabled, 'go') == 0)
    call add(g:polyglot_disabled, 'go')
  endif
endif

if filereadable(expand('~/.config/nvim/bundles.vim.local'))
  source ~/.config/nvim/bundles.vim.local
endif

" let g:deoplete#enable_at_startup = 1

" Initialize plugins
call plug#end()
