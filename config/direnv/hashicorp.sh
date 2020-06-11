if ! has find_version; then
  find_version() {
    # Look for matching versions in the given path, even if only given a partial version. This
    # will take something like `1.4` and find a local directory in `~/.foo-versions` called
    # `v1.4.80293`. If multiple directories match, it chooses the latest version.
    local host_directory="$1" wanted="$2" version_prefix="${3:-v}"

    find "$host_directory" -maxdepth 1 -mindepth 1 -type d -name "$wanted*" \
      | while IFS= read -r line; do echo "${line#${host_directory%/}/${version_prefix}}"; done \
      | sort -t . -k 1,1rn -k 2,2rn -k 3,3rn \
      | head -1
  }
fi

install_hashicorp_product() {
  local -r product="$(printf '%s\n' "$1" | tr '[:upper:]' '[:lower:]')"
  local -r product_versions_var="$(printf '%s\n' "$product" | tr '[:lower:]' '[:upper:]')_VERSIONS"
  eval "${product_versions_var}=\"\${${product_versions_var}:-\${HOME}/.\${product}-versions}\""
  # This ^^^ will ensure the value of (e.g., TERRAFORM_VERSIONS) is actually set
  eval "local -r product_versions_location=\"\${${product_versions_var}}\""
  # If `product` is `terraform`, ^^^ would equate to `${TERRAFORM_VERSIONS:-${HOME}/.terraform-versions}`
  # stored as `$product_versions_location` in this shell function. This allows us to defer to values already
  # set elsewhere, while having sane defaults otherwise.

  local -r version_prefix='v'
  local -r version="$2"

  local -r install_dir="${product_versions_location}/${version_prefix}${version}"
  local GO_OS
  local GO_ARCH

  if [ -z "${product_versions_location}" ] || [ ! -d "${product_versions_location}" ]; then
    log_error "Directory ${product_versions_location} (provided by \$${product_versions_var}) must exist!"
    return 1
  fi

  if [ -z "$version" ]; then
    log_error "Must specify version of ${product} to install with \`install_hashicorp_product\`"
    return 1
  fi

  if [ -e "$install_dir" ]; then
    log_status "Found ${product} ${version_prefix}${version} in ${product_versions_location}"
    return 0
  fi

  if uname -a 2>/dev/null | grep -qe 'Darwin' &>/dev/null; then
    GO_OS='darwin'
    GO_ARCH='amd64'
  else
    GO_OS='linux'
    case "$(uname -m)" in
      arm*|aarch*)
        if [ "$(getconf LONG_BIT)" == '64' ]; then
          GO_ARCH='arm64'
        else
          GO_ARCH='arm'
        fi
        ;;
      *)
        if [ "$(getconf LONG_BIT)" == '64' ]; then
          GO_ARCH='amd64'
        else
          GO_ARCH='386'
        fi
        ;;
    esac
  fi

  tmpdir="$(mkdir -p "$(direnv_layout_dir)/tmp" && printf '%s/tmp\n' "$(direnv_layout_dir)")"
  if ! curl -fSLo "${tmpdir}/${product}.zip" "https://releases.hashicorp.com/${product}/${version}/${product}_${version}_${GO_OS}_${GO_ARCH}.zip"; then
    log_error "Failed to download ${product} ${verison_prefix}${version}"
    return 1
  fi
  if has sha256sum && has awk; then
    if curl -fSLo "${tmpdir}/${product}_SHA256SUMS" "https://releases.hashicorp.com/${product}/${version}/${product}_${version}_SHA256SUMS"; then
      log_status "Checking download of ${product} against the posted checksum..."
      pushd "$tmpdir" 1>/dev/null 2>&1
      if ! awk "/_${GO_OS}_${GO_ARCH}/"' { print $1 "  " "'"${product}.zip"'" }' ./"${product}_SHA256SUMS" | sha256sum -c - 1>/dev/null; then
        log_error "Downloaded ${product}.zip does not match the posted checksum. ABORT!"
        return 1
      else
        log_status "Downloaded ${product}.zip matches the posted checksum"
      fi
      popd "$tmpdir" 1>/dev/null 2>&1
    fi
  fi
  mkdir -p "$install_dir"
  unzip -d "$install_dir" "${tmpdir}/${product}.zip"
}

use_hashicorp_product() {
  local -r product="$(printf '%s\n' "$1" | tr '[:upper:]' '[:lower:]')"
  local -r product_versions_var="$(printf '%s\n' "$product" | tr '[:lower:]' '[:upper:]')_VERSIONS"
  #: "${!${product_versions_var}:-${HOME}/.${product}-versions}"
  #local -r product_versions_location="${!${product_versions_var}}"
  eval "${product_versions_var}=\"\${${product_versions_var}:-\${HOME}/.\${product}-versions}\""
  # This ^^^ will ensure the value of (e.g., TERRAFORM_VERSIONS) is actually set
  eval "local -r product_versions_location=\"\${${product_versions_var}}\""
  # If `product` is `terraform`, ^^^ would equate to `${TERRAFORM_VERSIONS:-${HOME}/.terraform-versions}`
  # stored as `$product_versions_location` in this shell function. This allows us to defer to values already
  # set elsewhere, while having sane defaults otherwise.

  local -r version_prefix='v'
  local -r version="$2"

  local via=''
  local version_wanted product_prefix reported

  if [ -z "${product_versions_location}" ] || [ ! -d "${product_versions_location}" ]; then
    log_error "Directory ${product_versions_location} (provided by \$${product_versions_var}) must exist!"
    return 1
  fi

  if [ -z "$version" ]; then
    log_error "I do not know which ${product} version to load because one has not been specified!"
    return 1
  fi

  version_wanted="${version_prefix}${version}"

  product_prefix="$(find_version "${product_versions_location}" "$version_wanted" "$version_prefix")"
  reported="${product_prefix}"
  product_prefix="${product_versions_location}/${version_prefix}${product_prefix}"

  if [ ! -d "${product_prefix}" ]; then
    log_error "Could not find ${product} ${version_prefix}${version}. Attempting to download..."
    if install_hashicorp_product "${product}" "${version}"; then
      log_status "Installed ${product} ${version_prefix}${version} to ${product_versions_location}!"
    else
      log_error "Unable to install ${product} ${version_prefix}${version}"
      return 1
    fi

    # Try again
    product_prefix="$(find_version "${product_versions_location}" "$version_wanted" "$version_prefix")"
    reported="${product_prefix}"
    product_prefix="${product_versions_location}/${version_prefix}${product_prefix}"
  fi

  if [ "${reported}" != "${version}" ]; then
    log_status "Resolved ${product} '${version}' -> '${reported}'"
  fi
  PATH_add "$product_prefix"
}

use_terraform() {
  use_hashicorp_product 'terraform' "$1"
}

use_vault() {
  use_hashicorp_product 'vault' "$1"
}

use_consul() {
  use_hashicorp_product 'consul' "$1"
}

use_nomad() {
  use_hashicorp_product 'nomad' "$1"
}
