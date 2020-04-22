# load our own completion functions
if [ -e /usr/local/share/zsh/site-functions ]; then
  fpath=(/usr/local/share/zsh/site-functions $fpath)
fi
fpath=(~/.zsh/completion $fpath)

# completion
autoload -U compinit bashcompinit
compinit
bashcompinit

# if [ $commands[kubectl] ]; then
#   source <(kubectl completion zsh)
# fi
