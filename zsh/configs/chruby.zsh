# Load chruby if available
[ -f "/usr/local/share/chruby/chruby.sh" ] && \
  source "/usr/local/share/chruby/chruby.sh" \
  || true
# Load chruby auto-switching option with .ruby-version files
[ -f "/usr/local/share/chruby/auto.sh" ] && \
  source "/usr/local/share/chruby/auto.sh" \
  || true
