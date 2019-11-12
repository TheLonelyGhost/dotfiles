# load our own completion functions
fpath=(~/.zsh/completion /usr/local/share/zsh/site-functions $fpath)

# completion
autoload -U compinit bashcompinit
compinit
bashcompinit

if [ $commands[kubectl] ]; then
  source <(kubectl completion zsh)
fi
