if [ -e "${HOME}/.tool-versions" ] && grep -e '^java ' "${HOME}/.tool-versions" 1>/dev/null 2>&1; then
  . "${HOME}/.asdf/plugins/java/set-java-home.zsh"
fi
