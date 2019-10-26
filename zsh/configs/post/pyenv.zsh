if type pyenv &>/dev/null; then
  eval "$(pyenv init -)"
fi

if [ -e "${HOME}/.local/bin" ]; then
  PATH="${HOME}/.local/bin:${PATH}"
fi

if [ -e "${HOME}/.poetry/bin" ]; then
  PATH="${HOME}/.poetry/bin:$PATH"
fi

if [ ! -e "${HOME}/.zsh/configs/post/pipx.zsh" ]; then
  register-python-argcomplete pipx > "${HOME}/.zsh/configs/post/pipx.zsh"
fi
