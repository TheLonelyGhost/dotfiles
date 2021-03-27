if [ -e "${HOME}/.tool-versions" ] && grep -e '^java ' "${HOME}/.tool-versions" 1>/dev/null 2>&1; then
  asdf_update_java_home() {
    # shellcheck disable=SC2046
    JAVA_HOME=$(realpath $(dirname $(readlink -f $(asdf which java)))/../)
    export JAVA_HOME
  }
  autoload -U add-zsh-hook
  add-zsh-hook precmd asdf_update_java_home
fi
