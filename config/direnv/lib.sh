#!/usr/bin/env bash
# shellcheck disable=SC2181

if ! has log_error; then
  # Usage: log_error [<message> ...]
  #
  # Logs an error message. Acts like echo,
  # but wraps output in the standard direnv log format
  # (controlled by $DIRENV_LOG_FORMAT), and directs it
  # to stderr rather than stdout.
  #
  # Example:
  #
  #    log_error "Unable to find specified directory!"
  log_error() {
    local color_normal
    local color_error
    color_normal=$(tput sgr0)
    color_error=$(tput setaf 1)
    if [[ -n $DIRENV_LOG_FORMAT ]]; then
      local msg=$*
      # shellcheck disable=SC2059,1117
      printf "${color_error}${DIRENV_LOG_FORMAT}${color_normal}\n" "$msg" >&2
    fi
  }
fi

# Project-specific vim configurations
use_customized_vim() {
  local extravim
  extravim="$(find_up .vimrc)"
  if [ -n "$extravim" ] && [ "$extravim" != "${HOME}/.vimrc" ]; then
    log_status "Adding vim configurations: ${extravim}"
    path_add EXTRA_VIM "$extravim"
  fi
}
