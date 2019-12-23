# PATH changes
if [ -f "${HOME}/.path" ]; then
  . "${HOME}/.path"
fi

# ensure dotfiles bin directory is loaded first
PATH="$HOME/.bin:$HOME/.local/bin:/usr/local/sbin:$PATH"

export -U PATH
