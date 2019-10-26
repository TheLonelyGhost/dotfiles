if [ -e "${HOME}/.jabba/jabba.sh" ]; then
  source "${HOME}/.jabba/jabba.sh"
  if [ -n "$(jabba alias default)" ]; then
    jabba use default
  fi
fi
