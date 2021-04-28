#!/usr/bin/env bash
# shellcheck disable=SC2181,SC2223

use_hashicorp_product() {
  local -r product="${1,,}"
  local -r product_versions_var="${product^^}_VERSIONS"
  local -r product_prefix_var="${product^^}_VERSION_PREFIX"
  # If `product` is `terraform`, ^^^ would equate to `${TERRAFORM_VERSIONS:-${HOME}/.terraform-versions}`,
  # ensuring that the default value is actually set to something sane.
  local -r product_versions_location="${!product_versions_var}"
  # This ^^^ gives us the value of the install location base directory in a more easily used variable

  if [ -z "${!product_versions_var:-}" ] || ! [ -d "${!product_versions_var}" ]; then
    log_error "You must specify a \$${product_versions_var} environment variable and the directory specified must exist!"
    return 1
  fi

  local -r version_prefix="${!product_prefix_var}"
  local -r version="$2"

  local version_wanted product_prefix

  if [ ! -d "${product_versions_location}" ]; then
    log_error "Directory '${product_versions_location}' (provided by \$${product_versions_var}) must exist!"
    return 1
  fi

  if [ -z "$version" ]; then
    log_error "I do not know which ${product} version to load because one has not been specified!"
    return 1
  fi

  version_wanted="${version_prefix}${version}"

  product_prefix="$(semver_search "${product_versions_location}" "$version_prefix" "$version_wanted")"

  if [ ! -d "${product_versions_location}/${product_prefix}" ] || [ -z "${product_prefix}" ]; then
    log_error "Could not find ${product} ${version_prefix}${version}."
    return 1
  fi

  # With this included, it's getting too verbose. Let's just take it out:

  #local reported="${product_prefix}"
  #if [ "${reported}" != "${version}" ]; then
  #  log_status "Resolved ${product} '${version}' -> '${reported}'"
  #fi

  load_prefix "${product_versions_location}/${product_prefix}"
  hash -r
}

use_boundary() {
  use_hashicorp_product "boundary" "$1"
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

use_sentinel() {
  use_hashicorp_product "sentinel" "$1"
}

use_serf() {
  use_hashicorp_product "serf" "$1"
}

use_terraform() {
  use_hashicorp_product "terraform" "$1"
}

use_vagrant() {
  use_hashicorp_product "vagrant" "$1"
}

use_vault() {
  use_hashicorp_product "vault" "$1"
}

use_waypoint() {
  use_hashicorp_product "waypoint" "$1"
}
