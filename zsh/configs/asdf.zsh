if [ -e "${HOME}/.asdf/asdf.sh" ]; then
  . "${HOME}/.asdf/asdf.sh"
  fpath=("${ASDF_DIR}/completions" $fpath)
fi
