#!/usr/bin/env bash
set -euo pipefail

log() {
  local message
  if [ $# -gt 0 ]; then
    message="$*"
  else
    message=""
  fi
  printf "%b\n" "$message"
}
error() {
  local message
  if [ $# -gt 0 ]; then
    message="$*"
  else
    message=""
  fi
  printf "%b\n" "$message" 1>&2
}
fail() {
  local message
  if [ $# -gt 0 ]; then
    message="$*"
  else
    message=""
  fi
  printf "%b\n" "$message" 1>&2
  exit 1
}

on_os() {
  local expected_os
  expected_os="$1"; shift

  case "$expected_os" in
    mac)
      if [[ "$OSTYPE" == darwin* ]]; then
        eval "${@}"
        return $?
      fi
      ;;

    ubuntu)
      if [ "$(lsb_release -s -i 2>/dev/null)" = "ubuntu" ]; then
        eval "${@}"
        return $?
      fi
      ;;

    fedora)
      error "Fedora is unsupported at this time"
      ;;

    *)
      fail "Unknown OS: \"${expected_os}\""
      ;;
  esac
}

install_deps() {
  on_os 'mac' 'install_mac_deps'
  on_os 'ubuntu' 'install_ubuntu_deps'
}

install_mac_deps() {
  local PACKAGES=() TAPS=()

  if ! command -v git &>/dev/null; then
    PACKAGES+=('git')
  fi
  if ! command -v zsh &>/dev/null; then
    PACKAGES+=('zsh')
  fi

  if ! command -v rcup &>/dev/null; then
    TAPS+=('thoughtbot/formulae')
    PACKAGES+=('rcm')
  fi

  if ! command -v brew &>/dev/null; then
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  fi

  for tap in "${TAPS[@]}"; do
    brew tap "$tap"
  done

  if [ -n "${PACKAGES[*]}" ]; then
    brew install "${PACKAGES[*]}"
  else
    log "No packages to install"
  fi
}

install_ubuntu_deps() {
  local PACKAGES=() PPAS=()

  if ! command -v git &>/dev/null; then
    PACKAGES+=('git-core')
  fi

  if ! command -v zsh &>/dev/null; then
    PACKAGES+=('zsh')
  fi

  if ! command -v rcup &>/dev/null; then
    PPAS+=('martin-frost/thoughtbot-rcm')
    PACKAGES+=('rcm')
  fi

  for ppa in "${PPAS[@]}"; do
    sudo add-apt-repository -y "ppa:${ppa}"
  done

  if [ -n "${PACKAGES[*]}" ]; then
    sudo apt-get update

    sudo apt-get install -y "${PACKAGES[@]}"
  else
    log "No packages to install"
  fi
}

change_shell() {
  local shell
  shell="$1"; shift

  if [ "$SHELL" != "*/${shell}" ]; then
    chsh -s "$(command -v zsh)"
  else
    log "Shell is already \"${SHELL}\""
  fi
}

clone_repo() {
  local repo_url
  repo_url="$1"; shift

  if [ ! -f "${HOME}/.dotfiles/rcrc" ]; then
    git clone "$repo_url" "${HOME}/.dotfiles"
  else
    log "Dotfiles directory is already cloned"
  fi
}

main() {
  install_deps
  clone_repo "https://github.com/thelonelyghost/dotfiles.git"

  if [ -e "${HOME}/.dotfiles/rcrc" ]; then
    /usr/bin/env RCRC="${HOME}/.dotfiles/rcrc" rcup
  else
    fail "Dotfiles could not be cloned"
  fi
}


main
