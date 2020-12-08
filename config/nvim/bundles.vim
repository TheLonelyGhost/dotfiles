" Begin plugin definitions
call plug#begin('~/.local/share/nvim/plugged')

Plug 'editorconfig/editorconfig-vim'
Plug 'dense-analysis/ale' | Plug 'Shougo/deoplete.nvim', {'do': ':UpdateRemotePlugins'}
Plug 'sheerun/vim-polyglot'
Plug 'vim-test/vim-test' | Plug 'skywind3000/asyncrun.vim'
Plug 'altercation/vim-colors-solarized'
Plug 'airblade/vim-gitgutter'
Plug 'thelonelyghost/vim-inspec'
Plug 'junegunn/vim-emoji'

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

let g:deoplete#enable_at_startup = 1

" Initialize plugins
call plug#end()
