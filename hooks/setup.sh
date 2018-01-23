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
  local shell shell_path
  shell="$1"; shift
  shell_path=$(command -v "$shell")

  if [ "$SHELL" != "*/${shell}" ]; then
    if ! grep -qFe "/$shell_path" /etc/shells &>/dev/null; then
      log "Adding ${shell} to list of authorized shells"
      echo "$shell_path" | sudo tee -a /etc/shells
    fi

    log "Changing shell to be ${shell}"
    chsh -s "$shell_path"
  else
    log "Shell is already \"${SHELL}\""
  fi
}

update_repo() {
  local repo has_changes
  repo="${HOME}/.dotfiles"
  has_changes=false

  if [ -n "$(git -C "${repo}" status --porcelain)" ]; then
    git -C "${repo}" stash save --keep-index --include-untracked --all 'Dotfiles updater'
    has_changes=true
  fi

  git -C "${repo}" fetch origin
  git -C "${repo}" rebase origin/master

  if $has_changes; then
    git -C "${repo}" stash pop
  fi
}

clone_repo() {
  local repo_url destination
  repo_url="$1"; shift
  destination="$1"; shift

  git clone "${repo_url}" "${destination}"
}

main() {
  install_deps

  if [ ! -d "${HOME}/.dotfiles/.git" ]; then
    clone_repo "https://gitlab.com/thelonelyghost/dotfiles.git" "${HOME}/.dotfiles"
    [ -e "${HOME}/.dotfiles/rcrc" ] || fail "Dotfiles could not be cloned"
  else
    update_repo
    [ -e "${HOME}/.dotfiles/rcrc" ] || fail "Dotfiles are missing RCM configuration at [repo-root]/rcrc"
  fi

  /usr/bin/env RCRC="${HOME}/.dotfiles/rcrc" rcdn

  # Run it a few times since we cache the steps pretty well anyway
  /usr/bin/env RCRC="${HOME}/.dotfiles/rcrc" rcup || true
  change_shell 'zsh'
  # Run it twice in a row just in case there are weird errors the first time
  /usr/bin/env RCRC="${HOME}/.dotfiles/rcrc" rcup || true
  /usr/bin/env RCRC="${HOME}/.dotfiles/rcrc" rcup

  log
  log "======> Exit out of your current shell and reopen it <======"
  log
}


main
