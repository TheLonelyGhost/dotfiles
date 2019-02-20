# vim: ft=zsh
if (( $+commands[tag] )); then
  export TAG_SEARCH_PROG='rg'
  tag() { command tag "$@"; source ${TAG_ALIAS_FILE:-/tmp/tag_aliases} 2>/dev/null }
  alias rg=tag
fi
