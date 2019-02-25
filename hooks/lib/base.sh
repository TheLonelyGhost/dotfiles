#!/usr/bin/env bash

__message() {
  printf '>>  %b\n' "$*"
}

__error() {
  __message "$*" >&2
}

__fatal() {
  __error "$*"
  exit 1
}

__get_cmd() {
  local exe alternate
  exe="$1"
  alternate="${2:-}"
  if command -v "$exe" &>/dev/null; then
    command -v "$exe"
  elif [ -n "$alternate" ] && [ -x "$alternate" ]; then
    printf '%s\n' "$alternate"
  else
    __fatal "Could not find \`$exe' binary"
  fi
}

is_linux() {
  if uname -a 2>/dev/null | grep -qe '.*GNU/Linux' &>/dev/null; then
    # Must not be a linux variant
    return 0
  fi

  return 1
}

is_ubuntu() {
  if is_linux && command -v 'apt-get' &>/dev/null; then
    return 0
  fi

  return 1
}

is_mac() {
  if uname -a 2>/dev/null | grep -qe 'Darwin' &>/dev/null; then
    # Must not be macOS
    return 0
  fi

  return 1
}
