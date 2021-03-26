#!/usr/bin/env bash
# shellcheck disable=SC2181

# Project-specific vim configurations
use_customized_vim() {
  local extravim
  extravim="$(find_up .vimrc)"
  if [ -n "$extravim" ] && [ "$extravim" != "${HOME}/.vimrc" ]; then
    log_status "Adding vim configurations: ${extravim}"
    path_add EXTRA_VIM "$extravim"
  fi
}
