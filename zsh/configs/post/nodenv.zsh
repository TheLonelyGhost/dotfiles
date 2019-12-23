path=("$HOME/.nodenv/bin" $path)

if type nodenv &>/dev/null; then
  eval "$(nodenv init -)"
fi
