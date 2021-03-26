#!/usr/bin/env bash
# shellcheck disable=SC2181,SC2223

use_hashicorp_product() {
  local -r product="${1,,}"
  local -r product_versions_var="${product^^}_VERSIONS"
  local -r product_prefix_var="${product^^}_VERSION_PREFIX"
  : ${!product_versions_var:=${HOME}/.${product}-versions}
  : ${!product_prefix_var:=v}
  # If `product` is `terraform`, ^^^ would equate to `${TERRAFORM_VERSIONS:-${HOME}/.terraform-versions}`,
  # ensuring that the default value is actually set to something sane.
  local -r product_versions_location="${!product_versions_var}"
  # This ^^^ gives us the value of the install location base directory in a more easily used variable

  local -r version_prefix="${!product_prefix_var}"
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
  use_hashicorp_product "terraform" "$1"
}

use_vault() {
  use_hashicorp_product "vault" "$1"
}

use_consul() {
  use_hashicorp_product "consul" "$1"
}

use_nomad() {
  use_hashicorp_product "nomad" "$1"
}

use_packer() {
  use_hashicorp_product "packer" "$1"
}

use_waypoint() {
  use_hashicorp_product "waypoint" "$1"
}

use_boundary() {
  use_hashicorp_product "boundary" "$1"
}
