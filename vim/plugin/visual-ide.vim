set ruler            " show the cursor position all the time
set showcmd          " display incomplete commands
set laststatus=2     " Always display the status line
set wildmenu " Autocomplete menu at the bottom

set textwidth=80     " Set max width
set colorcolumn=+1   " Color the 81st column so max width is obvious

set number           " Use line-numbering
set numberwidth=5    " Make line numbers 5 chars wide

set diffopt+=vertical " Always use vertical diffs

set splitright splitbelow " Splits: left -> right, top -> bottom

set backspace=indent,eol,start " Backspace deletes like most programs in insert mode

let g:netrw_banner=0 " disable annoying banner
