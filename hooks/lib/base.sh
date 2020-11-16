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

__debug() {
  :
  # __message "[DEBUG] >> ${*}"
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
  if is_linux && grep -qFe 'UBUNTU' /etc/os-release &>/dev/null; then
    return 0
  fi

  return 1
}

is_kali() {
  if is_linux && grep -qFe 'kali' /etc/os-release &>/dev/null; then
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

is_graphical() {
  if is_mac || command -v Xorg &>/dev/null; then
    return 0
  fi

  return 1
}

is_wsl() {
  if grep -qFe 'icrosoft' /proc/version &>/dev/null; then
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
  local file checksumfile
  file="$1"
  checksumfile="${file}.md5"

  if [ -f "$checksumfile" ] && __md5_verify "$file" "$checksumfile"; then
    return 0
  fi

  source "$file"

  __md5_generate "$file" > "$checksumfile"
}

__verify_base_and_local_md5() {
  __md5_verify "$1" && ([ ! -e "$1".local ] || __md5_verify "$1".local)
}

__generate_base_and_local_md5() {
  if [ -e "$1" ]; then
    __md5_generate "$1" > "$1".md5
  fi
  if [ -e "$1".local ]; then
    __md5_generate "$1".local > "$1".local.md5
  fi
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

set-git-repo() {
  local clone_dir clone_url project_name branch is_stashed
  clone_dir="$1"
  clone_url="$2"
  project_name="${3-$(basename -s .git -- "$clone_url")}"
  branch="${4-master}"
  is_stashed=0

  if ! command -v git &>/dev/null; then
    __fatal 'Missing dependency: git'
  fi

  if [ ! -e "${clone_dir}/.git" ]; then
    command git clone "${clone_url}" "${clone_dir}"
    command git -C "${clone_dir}" checkout "$branch" &>/dev/null
  elif command git -C "${clone_dir}" ls-remote origin | grep -Fe 'master pushes to master' | grep -qFe 'local out of date' &>/dev/null; then
    __message "${project_name} is out of date. Updating..."
    if command git -C "${clone_dir}" status --porcelain | grep -e '^ *[A-Z?]' &>/dev/null; then
      command git -C "${clone_dir}" stash --all
      is_stashed=1
    fi
    command git -C "${clone_dir}" pull --rebase origin "$branch"
    if [ "$is_stashed" -eq 1 ]; then
      # We want to let the person know if there are merge errors
      command git -C "${clone_dir}" stash pop
    fi
  else
    __message "${project_name} is up-to-date"
  fi
}

abspath() {
  # shellcheck disable=SC2164
  printf '%s/%s\n' "$(cd "$(dirname -- "$1")"; pwd -P)" "$(basename -- "$1")"
}

mktemp-dir() {
  local tmpdir
  tmpdir="$(mktemp -d -t dotfiles-XXXXXXXXXXXXXXX)"
  TEMP_DIRS+=("$tmpdir")
  printf '%s\n' "$(abspath "$tmpdir")"
}

is-in-path() {
  local directory bin
  bin="$1"; shift
  if [ -e "$bin" ] && [ -f "$bin" ]; then
    directory=$(dirname "${bin%/}")
  else
    directory="${bin%/}"; shift
  fi

  if grep -qF -e "$directory" <(printf '%s' "$PATH") &>/dev/null; then
    return 0
  else
    return 1
  fi
}

plist-exec() {
  if [ $# -lt 2 ]; then
    printf '%s\n' "USAGE:   plist-exec <plist> <query>" 1>&2
    return 1
  fi

  local plist query
  plist="${HOME}/Library/Preferences/$1"; shift
  query="$1"; shift

  if [ ! -e "$plist" ]; then
    printf 'No plist file found at %s\n' "$plist" 1>&2
    return 1
  fi

  /usr/libexec/PlistBuddy -c "$query" "$plist"
}

plist-ensure-value() {
  local plist attr_tree desired_value value_datatype

  if [ ! $# -gt 3 ]; then
    printf '%s\n' "USAGE:   plist-ensure-value <plist> <attr-tree> <desired-value> <value-datatype>" 1>&2
    return 1
  fi

  plist="$1"; shift
  attr_tree="$1"; shift
  desired_value="$1"; shift
  value_datatype="$1"; shift

  if ! plist-exec "$plist" "Print ${attr_tree}" &>/dev/null; then
    # Needs to be created
    plist-exec "$plist" "Add ${attr_tree} ${value_datatype} ${desired_value}" &>/dev/null
  elif ! plist-exec "$plist" "Print ${attr_tree}" | grep -qFe "$desired_value" &>/dev/null; then
    # Needs to be changed
    case "$value_datatype" in
      'dict'|'array')
        # skip
        ;;
      *)
        plist-exec "$plist" "Set ${attr_tree} '${desired_value}'" &>/dev/null
        ;;
    esac
  else
    __debug "PList: '${attr_tree}' already exists as type '${value_datatype}' with value '${desired_value}'"
  fi
}
