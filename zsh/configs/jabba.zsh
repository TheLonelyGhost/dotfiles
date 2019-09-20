if [ -e "${HOME}/.jabba/jabba.sh" ]; then
  . "${HOME}/.jabba/jabba.sh"
  if [ -n "$(jabba alias default)" ]; then
    jabba use default
  fi
fi
