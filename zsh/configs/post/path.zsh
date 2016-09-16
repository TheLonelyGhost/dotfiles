# PATH changes
[ -f "$HOME/.path" ] && \
  source "$HOME/.path" \
  || true

# ensure dotfiles bin directory is loaded first
PATH="$HOME/.bin:/usr/local/sbin:$PATH"

# load rbenv if available
if command -v rbenv >/dev/null; then
  eval "$(rbenv init - --no-rehash)"
fi

# `mkdir -p .git/safe' in the root of repositories you trust
PATH=".git/safe/../../bin:$PATH"

export -U PATH
