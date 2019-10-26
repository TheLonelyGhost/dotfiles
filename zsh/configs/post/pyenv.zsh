if type pyenv &>/dev/null; then
  eval "$(pyenv init -)"
fi

if [ -e "${HOME}/.local/bin" ]; then
  PATH="${HOME}/.local/bin:${PATH}"
fi

if [ -e "${HOME}/.poetry/bin" ]; then
  PATH="${HOME}/.poetry/bin:$PATH"
fi
