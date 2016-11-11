# PATH changes
[ -f "$HOME/.path" ] && \
  source "$HOME/.path" \
  || true

# ensure dotfiles bin directory is loaded first
PATH="$HOME/.bin:$HOME/.local/bin:/usr/local/sbin:$PATH"

export -U PATH
