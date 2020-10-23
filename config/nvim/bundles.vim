" Begin plugin definitions
call plug#begin('~/.local/share/nvim/plugged')

Plug 'editorconfig/editorconfig-vim'
" Plug 'w0rp/ale'
Plug 'sheerun/vim-polyglot'
" Plug 'neoclide/coc.nvim', { 'tag': '*', 'branch': 'release' }
Plug 'vim-test/vim-test' | Plug 'skywind3000/asyncrun.vim'
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

" Initialize plugins
call plug#end()
