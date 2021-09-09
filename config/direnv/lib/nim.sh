#!/usr/bin/env bash
# shellcheck disable=SC2181,SC2223

use_nim() {
  mkdir -p nimbledeps/pkgs

  export NIMBLE_DIR="${PWD}/nimbledeps"
  path_add PATH "${PWD}/nimbledeps/bin"
}
