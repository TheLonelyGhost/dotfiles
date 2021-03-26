#!/usr/bin/env bash
# shellcheck disable=SC2181,SC2223

install_hashicorp_product() {
  local -r product="${1,,}"
  local -r product_versions_var="${product^^}_VERSIONS"
  : ${!product_versions_var:=${HOME}/.${product}-versions}
  # If `product` is `terraform`, ^^^ would equate to `${TERRAFORM_VERSIONS:-${HOME}/.terraform-versions}`,
  # ensuring that the default value is actually set to something sane.
  local -r product_versions_location="${!product_versions_var}"
  # This ^^^ gives us the value of the install location base directory in a more easily used variable

  local -r version_prefix='v'
  local -r version="$2"

  local -r install_dir="${product_versions_location}/${version_prefix}${version}"
  local GO_OS
  local GO_ARCH

  if [ ! -d "${product_versions_location}" ]; then
    log_error "Directory '${product_versions_location}' (provided by \$${product_versions_var}) must exist!"
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
    log_error "Failed to download ${product} ${version_prefix}${version}"
    return 1
  fi
  if has sha256sum && has awk; then
    if curl -fSLo "${tmpdir}/${product}_SHA256SUMS" "https://releases.hashicorp.com/${product}/${version}/${product}_${version}_SHA256SUMS"; then
      log_status "Checking download of ${product} against the posted checksum..."
      pushd "$tmpdir" 1>/dev/null 2>&1 || return 1 
      if ! awk "/_${GO_OS}_${GO_ARCH}/"' { print $1 "  " "'"${product}.zip"'" }' ./"${product}_SHA256SUMS" | sha256sum -c - 1>/dev/null; then
        log_error "Downloaded ${product}.zip does not match the posted checksum. ABORT!"
        return 1
      else
        log_status "Downloaded ${product}.zip matches the posted checksum"
      fi
      popd "$tmpdir" 1>/dev/null 2>&1 || return 1
    fi
  fi
  mkdir -p "$install_dir"
  unzip -d "$install_dir" "${tmpdir}/${product}.zip"
}

use_hashicorp_product() {
  local -r product="${1,,}"
  local -r product_versions_var="${product^^}_VERSIONS"
  : ${!product_versions_var:=${HOME}/.${product}-versions}
  # If `product` is `terraform`, ^^^ would equate to `${TERRAFORM_VERSIONS:-${HOME}/.terraform-versions}`,
  # ensuring that the default value is actually set to something sane.
  local -r product_versions_location="${!product_versions_var}"
  # This ^^^ gives us the value of the install location base directory in a more easily used variable

  local -r version_prefix='v'
  local -r version="$2"

  local version_wanted product_prefix reported

  if [ ! -d "${product_versions_location}" ]; then
    log_error "Directory '${product_versions_location}' (provided by \$${product_versions_var}) must exist!"
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
  if has hashi-env; then
    TERRAFORM_VERSION="$(hashi-env list terraform | grep -Fe "$1" | head -n1)"
    export TERRAFORM_VERSION
  else
    use_hashicorp_product 'terraform' "$1"
  fi
}

use_vault() {
  if has hashi-env; then
    VAULT_VERSION="$(hashi-env list vault | grep -Fe "$1" | head -n1)"
    export VAULT_VERSION
  else
    use_hashicorp_product 'vault' "$1"
  fi
}

use_consul() {
  if has hashi-env; then
    CONSUL_VERSION="$(hashi-env list consul | grep -Fe "$1" | head -n1)"
    export CONSUL_VERSION
  else
    use_hashicorp_product 'consul' "$1"
  fi
}

use_nomad() {
  if has hashi-env; then
    NOMAD_VERSION="$(hashi-env list nomad | grep -Fe "$1" | head -n1)"
    export NOMAD_VERSION
  else
    use_hashicorp_product 'nomad' "$1"
  fi
}

use_packer() {
  if has hashi-env; then
     PACKER_VERSION="$(hashi-env list packer | grep -Fe "$1" | head -n1)"
     export PACKER_VERSION
  else
    use_hashicorp_product 'packer' "$1"
  fi
}
