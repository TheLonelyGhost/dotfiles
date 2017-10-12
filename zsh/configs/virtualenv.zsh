# load the virtualenv wrapper
if [ -e "${HOME}/.local/bin/virtualenvwrapper.sh" ]; then
  VIRTUALENVWRAPPER_SCRIPT="${HOME}/.local/bin/virtualenvwrapper.sh"
elif [ -e "${HOME}/Library/Python/3.6/bin/virtualenvwrapper.sh" ]; then
  VIRTUALENVWRAPPER_SCRIPT="${HOME}/Library/Python/3.6/bin/virtualenvwrapper.sh"
elif [ -e "${HOME}/Library/Python/2.7/bin/virtualenvwrapper.sh" ]; then
  VIRTUALENVWRAPPER_SCRIPT="${HOME}/Library/Python/2.7/bin/virtualenvwrapper.sh"
else
  VIRTUALENVWRAPPER_SCRIPT="$(command -v 'virtualenvwrapper.sh' 2>/dev/null)"
fi

if [ -n "${VIRTUALENVWRAPPER_SCRIPT}" ] && [ -x "${VIRTUALENVWRAPPER_SCRIPT}" ]; then
  export VIRTUALENVWRAPPER_SCRIPT

  # Try to lazy-load it first, else load the full thing
  if [ -e "${HOME}/.local/bin/virtualenvwrapper_lazy.sh" ]; then
    source "${HOME}/.local/bin/virtualenvwrapper_lazy.sh"
  elif [ -e "${HOME}/Library/Python/3.6/bin/virtualenvwrapper_lazy.sh" ]; then
    source "${HOME}/Library/Python/3.6/bin/virtualenvwrapper_lazy.sh"
  elif [ -e "${HOME}/Library/Python/2.7/bin/virtualenvwrapper_lazy.sh" ]; then
    source "${HOME}/Library/Python/2.7/bin/virtualenvwrapper_lazy.sh"
  elif command -v 'virtualenvwrapper_lazy.sh' &>/dev/null; then
    source "$(command -v 'virtualenvwrapper.sh' 2>/dev/null)"
  else
    # Use the actual virtualenv wrapper, not the lazy loader
    source "${VIRTUALENVWRAPPER_SCRIPT}"
  fi
fi
