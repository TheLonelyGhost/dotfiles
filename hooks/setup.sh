#!/bin/bash
set -e


function log() {
  echo $@
}
function error() {
  echo $@ 1>&2
}
function fail() {
  error $@
  exit 1
}

function on_os() {
  local expected_os="$1"
  shift

  case "$expected_os" in

    mac)
      if [ "$OSTYPE" = darwin* ]; then
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

function install_deps() {
  on_os "mac" install_mac_deps
  on_os "ubuntu" install_ubuntu_deps
}

function install_mac_deps() {
  local PACKAGES="" TAPS=""

  command -v git &>/dev/null ||
    PACKAGES="$PACKAGES git"

  command -v zsh &>/dev/null ||
    PACKAGES="$PACKAGES zsh"

  command -v rcup &>/dev/null ||
    TAPS="$TAPS thoughtbot/formulae" &&
    PACKAGES="$PACKAGES rcm" ||
    true

  for tap in $TAPS; do
    brew tap $tap
  done

  if [ -n "$PACKAGES" ]; then
    brew install $PACKAGES
  else
    log "No packages to install"
  fi
}

function install_ubuntu_deps() {
  local PACKAGES="" PPAS=""

  command -v git &>/dev/null ||
    PACKAGES="$PACKAGES git-core"

  command -v zsh &>/dev/null ||
    PACKAGES="$PACKAGES zsh"

  command -v rcup &>/dev/null ||
    PPAS="$PPAS martin-frost/thoughtbot-rcm" &&
    PACKAGES="$PACKAGES rcm" ||
    true

  for ppa in $PPAS; do
    sudo add-apt-repository -y ppa:${ppa}
  done

  if [ -n "$PACKAGES" ]; then
    sudo apt-get update

    sudo apt-get install -y $PACKAGES
  else
    log "No packages to install"
  fi
}

function change_shell() {
  local shell="$1"
  if [ "$SHELL" != "*/${shell}" ]; then
    chsh -s $(which zsh)
  else
    log "Shell is already \"${SHELL}\""
  fi
}

function clone_repo() {
  local repo_url="$1"
  shift

  if [ ! -f "${HOME}/.dotfiles/rcrc" ]; then
    git clone "$repo_url" "${HOME}/.dotfiles"
  else
    log "Dotfiles directory is already cloned"
  fi
}

function main() {
  install_deps
  clone_repo "https://gitlab.com/thelonelyghost/dotfiles.git"

  /usr/bin/env RCRC="${HOME}/.dotfiles/rcrc" rcup
}


main
