if [ -e "${HOME}/.pyenv/shims" ]; then
  PATH="${HOME}/.pyenv/shims:${PATH}"
fi

if [ -e "${HOME}/.local/bin" ]; then
  PATH="${HOME}/.local/bin:${PATH}"
fi
