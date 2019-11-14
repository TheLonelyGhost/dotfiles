#!/usr/bin/env bash

HOOK_DIR="${0%/*}/../"

declare -a TEMP_DIRS=()

__cleanup_temp() {
  if [ "${#TEMP_DIRS[@]}" -eq 0 ]; then return 0; fi

  for dir in "${TEMP_DIRS[@]}"; do
    if [ -e "${dir}" ] && [ -n "${dir}" ]; then
      rm -rf "${dir}"
    fi
  done
}

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
    # Must be macOS
    return 0
  fi

  return 1
}

get-goos() {
  if is_mac; then
    printf 'darwin\n'
  elif is_linux; then
    printf 'linux\n'
  else
    __fatal 'Unknown operating system'
  fi
}

get-goarch() {
  if is_mac; then
    printf '%s\n' "amd64"
  elif is_linux; then
    case "$(uname -m)" in
      arm*|aarch*)
        if [ "$(getconf LONG_BIT)" == '64' ]; then
          printf '%s\n' "arm64"
        else
          printf '%s\n' "arm"
        fi
        ;;
      *)
        if [ "$(getconf LONG_BIT)" == '64' ]; then
          printf '%s\n' "amd64"
        else
          printf '%s\n' "386"
        fi
        ;;
    esac
  else
    __fatal 'Unsupported system to find the golang-based target architecture'
  fi
}

__md5_generate() {
  local file=$1
  openssl md5 "$file" | sed -e 's/MD5(.*)= //g'
}

__md5_verify() {
  local file=$1
  local checksumfile=${2:-"${file}.md5"}
  #echo "Verifying ${file} with ${checksumfile}"

  if diff -q <(__md5_generate "$file") <(cat "$checksumfile") &>/dev/null; then
    return 0
  else
    return 1
  fi
}

__verify_or_source() {
  local file="$1"
  local checksumfile="${file}.md5"

  if [ -f "$checksumfile" ] && __md5_verify "$file" "$checksumfile"; then
    return 0
  fi

  source "$file"

  __md5_generate "$file" > "$checksumfile"
}

__install_packages() {
  local package_manager
  package_manager="$1"; shift
  if [ -f "${HOOK_DIR}/packages/${package_manager}" ]; then
    __verify_or_source "${HOOK_DIR}/packages/${package_manager}"
  else
    __error "No such manifest: '${HOOK_DIR}/packages/${package_manager}'"
  fi
}

abspath() {
  printf '%s/%s\n' "$(cd "$(dirname -- "$1")"; pwd -P)" "$(basename -- "$1")"
}

mktemp-dir() {
  local tmpdir
  if is_mac; then
    tmpdir="$(mktemp -d -t /tmp/dotfiles-XXXXXXXXXXXXXXX)"
  else
    tmpdir="$(mktemp -d -t dotfiles-XXXXXXXXXXXXXXX)"
  fi
  TEMP_DIRS+=("$tmpdir")
  printf '%s\n' "$(abspath "$tmpdir")"
}
