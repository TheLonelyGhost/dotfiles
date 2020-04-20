fpath=("${HOME}/.zsh/themes" $fpath)

setopt promptsubst
autoload -Uz promptinit
promptinit

prompt thelonelyghost
