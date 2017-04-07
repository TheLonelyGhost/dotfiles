let mapleader=' '

" Don't litter the filesystem with vim artifacts
set nobackup
set nowritebackup
set noswapfile
set nu

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
augroup END

" Status Line
set statusline=%#warningmsg#\ %{SyntasticStatuslineFlag()}%* " Left
set statusline+=%=
" '(row,column)'
set statusline+=(%l,%c) " Middle
set statusline+=%=
" (relative) filename, filetype, modified indicator, read-only indicator, preview-only indicator
set statusline+=%f\ %y%m%r%w " Right

" Disable search match highlight
nnoremap <silent> <leader><space> :silent noh<CR>
" Remove trailing whitespace
nnoremap <silent> <leader>W :silent %s/\s\+$//g<CR>

" Tab width = 2 && spaces instead of tabs
set expandtab sts=2 ts=2 sw=2
