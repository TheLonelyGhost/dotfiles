" Set spellfile to location that is guaranteed to exist, can be symlinked to
" Dropbox or kept in Git and managed with other dotfiles using rcm.
set spellfile=$HOME/.vim-spell-en.utf-8.add
set dictionary+=$HOME/.vim-spell-en.utf-8.add

" Autocomplete with dictionary words when spell check is on
"set complete+=kspell

" Setup a thesaurus
set thesaurus+=$HOME/.vim/mthesaur.txt

" Setup a default dictionary
set dictionary+=/usr/share/dict/words
