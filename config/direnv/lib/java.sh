#!/usr/bin/env bash

use_java() {
  if [ ! -e "${HOME}/.jabba/jabba.sh" ]; then
    log_error 'Not found: jabba. Please install from https://github.com/shyiko/jabba and then run `direnv reload`'
    exit 1
  fi

  . "${HOME}/.jabba/jabba.sh"

  if [ -n "${1:-}" ]; then
    jabba use "${1}"
  elif [ -z "${1:-}" ] && [ -n "$(jabba alias default)" ]; then
    jabba use default
  else
    log_error 'No "default" java found. Please set it with `jabba alias default {version}`'
  fi

  if [ -x "$(expand_path ./mvnw)" ]; then
    mkdir -p "$(direnv_layout_dir)/bin"
    command ln -fs "$(expand_path ./mvnw)" "$(direnv_layout_dir)/bin/mvn"
    PATH_add "$(direnv_layout_dir)/bin"
  fi
  if [ -x "$(expand_path ./gradlew)" ]; then
    mkdir -p "$(direnv_layout_dir)/bin"
    command ln -fs "$(expand_path ./gradlew)" "$(direnv_layout_dir)/bin/gradle"
    PATH_add "$(direnv_layout_dir)/bin"
  fi

  hash -r

  # Not needed since direnv reverts it for us, so we're
  # unsetting it to reduce noise in the direnv diff
  unset JAVA_HOME_BEFORE_JABBA
}
