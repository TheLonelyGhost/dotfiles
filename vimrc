" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if (&t_Co > 2 || has('gui_running')) && !exists('syntax_on')
  syntax on
endif

" Leader
let g:mapleader=' '

" Don't litter the filesystem with vim artifacts...
set nobackup
set nowritebackup
set noswapfile       " http://robots.thoughtbot.com/post/18739402579/global-gitignore#comment-458413287

" Undo up to 50 times
set history=50

set incsearch        " Start searching as soon as '/' is typed
set path+=**         " Allow :find to look in subdirectories of where vim was opened
set nojoinspaces     " Use one space, not two, after punctuation

" Automatically :write before running commands. VERY useful if using a shell command on open file
set autowrite

if filereadable(expand('~/.vimrc.bundles'))
  source ~/.vimrc.bundles
endif

filetype plugin indent on

" ======================================
" |     Overwrite, despite plugins     |
" ======================================

" Display extra whitespace
scriptencoding utf-8
  set list listchars=tab:»·,trail:·,nbsp:·
scriptencoding

augroup vimrcEx
  autocmd!

  " When editing a file, always jump to the last known cursor position.
  " Don't do it for commit messages, when the position is invalid, or when
  " inside an event handler (happens when dropping a file on gvim).
  autocmd BufReadPost *
    \ if &ft != 'gitcommit' && line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif

  " Set syntax highlighting for specific file types
  autocmd BufRead,BufNewFile *.md set filetype=markdown
  autocmd BufRead,BufNewFile .{jscs,jshint,eslint}rc set filetype=json
  autocmd BufRead,BufNewFile .envrc set filetype=sh
  autocmd BufRead,BufNewFile .zsh{rc,rc.local,env,env.local} set filetype=zsh
augroup END

" Vim-wiki settings
let g:vimwiki_list = [{
  \ 'path': '~/vimwiki',
  \ 'nested_syntaxes': {
  \   'ruby': 'ruby',
  \   'elixir': 'elixir',
  \   'javascript': 'javascript',
  \   'bash': 'sh'
  \ }
\ }]

" =============================================
" |           Aliases / Key Mappings          |
" =============================================

" Disable search match highlight
nnoremap <silent> <leader><space> :silent noh<CR>

" Remove trailing whitespace
nnoremap <silent> <leader>W :silent %s/\s\+$//g<CR>


" =============================================
" |                   Theme                   |
" =============================================
colorscheme vividchalk


" HOOK: Local config
if filereadable($HOME . '/.vimrc.local')
  source $HOME/.vimrc.local
endif

