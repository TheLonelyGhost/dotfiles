#!/usr/bin/env bash
# shellcheck disable=SC2181

KUBECTL_VERSIONS="${KUBECTL_VERSIONS-${HOME}/.kubectl-versions}"
HELM_VERSIONS="${HELM_VERSIONS-${HOME}/.helm-versions}"

install_kubectl() {
  if [ -z "${KUBECTL_VERSIONS}" ] || [ ! -d "${KUBECTL_VERSIONS}" ]; then
    log_error "You must specify a \$KUBECTL_VERSIONS environment variable and the directory specified must exist!"
    return 1
  fi

  local version="$1"
  local kubectl_version_prefix='v'
  local install_dir="${KUBECTL_VERSIONS}/${kubectl_version_prefix}${version}"
  local GO_OS GO_ARCH

  if [ -z "$version" ]; then
    log_error 'Must specify version of kubectl to install with `install_kubectl`'
    return 1
  fi

  if [ -e "$install_dir" ]; then
    log_status "Found kubectl ${kubectl_version_prefix}${version} in ${KUBECTL_VERSIONS}"
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

  curl -SLo "${tmpdir}/kubectl" "https://storage.googleapis.com/kubernetes-release/release/${kubectl_version_prefix}${version}/bin/${GO_OS}/${GO_ARCH}/kubectl"
  mkdir -p "$install_dir"
  chmod +x "${tmpdir}/kubectl" && mv "${tmpdir}/kubectl" "${install_dir}/kubectl"
}

use_kubectl() {
  local version="$1"
  local via=''
  local kubectl_version_prefix='v'
  local kubectl_wanted kubectl_prefix reported

  if [ -z "${KUBECTL_VERSIONS}" ] || [ ! -d "${KUBECTL_VERSIONS}" ]; then
    log_error "You must specify a \$KUBECTL_VERSIONS environment variable and the directory specified must exist!"
    return 1
  fi

  if [ -z "$version" ]; then
    log_error "I do not know which kubectl version to load because one has not been specified!"
    return 1
  fi

  helm_wanted="${kubectl_version_prefix}${version}"
  helm_prefix="$(
    # Look for matching python versions in $KUBECTL_VERSIONS path
    # Strip possible "/" suffix from $KUBECTL_VERSIONS, then use that to
    # Strip $KUBECTL_VERSIONS/$kubectl_version_prefix prefix from line.
    # Sort by version: split by "." then reverse numeric sort for each piece of the version string
    # The first one is the highest
    find "$KUBECTL_VERSIONS" -maxdepth 1 -mindepth 1 -type d -name "$kubectl_wanted*" \
      | while IFS= read -r line; do echo "${line#${KUBECTL_VERSIONS%/}/${kubectl_version_prefix}}"; done \
      | sort -t . -k 1,1rn -k 2,2rn -k 3,3rn \
      | head -1
  )"
  reported="${kubectl_prefix}"
  helm_prefix="${KUBECTL_VERSIONS}/${kubectl_version_prefix}${kubectl_prefix}"

  if [ ! -d "$kubectl_prefix" ]; then
    log_error "Unable to load Kubernetes CLI binary (kubectl) for version (${version}) in (${KUBECTL_VERSIONS})!"
    return 1
  fi

  if [ "$reported" != "${version}" ]; then
    log_status "Resolved kubectl '${version}' -> '$reported'"
  fi
  PATH_add "$kubectl_prefix"
}

install_helm() {
  if [ -z "${HELM_VERSIONS}" ] || [ ! -d "${HELM_VERSIONS}" ]; then
    log_error "You must specify a \$HELM_VERSIONS environment variable and the directory specified must exist!"
    return 1
  fi

  local version="$1"
  local helm_version_prefix='v'
  local install_dir="${HELM_VERSIONS}/${helm_version_prefix}${version}"
  local GO_OS GO_ARCH

  if [ -z "$version" ]; then
    log_error 'Must specify version of helm to install with `install_helm`'
    return 1
  fi

  if [ -e "$install_dir" ]; then
    log_status "Found helm ${helm_version_prefix}${version} in ${HELM_VERSIONS}"
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
  curl -SLo "${tmpdir}/helm.tgz" "https://get.helm.sh/helm-${helm_version_prefix}${version}-${GO_OS}-${GO_ARCH}.tar.gz"
  mkdir -p "$install_dir"
  tar xzf "${tmpdir}/helm.tgz" -C "$install_dir" --strip-components=1
}

use_helm() {
  local version="$1"
  local via=''
  local helm_version_prefix='v'
  local helm_wanted helm_prefix reported

  if [ -z "${HELM_VERSIONS}" ] || [ ! -d "${HELM_VERSIONS}" ]; then
    log_error "You must specify a \$HELM_VERSIONS environment variable and the directory specified must exist!"
    return 1
  fi

  if [ -z "$version" ]; then
    log_error "I do not know which Helm version to load because one has not been specified!"
    return 1
  fi

  helm_wanted="${helm_version_prefix}${version}"
  helm_prefix="$(
    # Look for matching python versions in $PYTHON_VERSIONS path
    # Strip possible "/" suffix from $PYTHON_VERSIONS, then use that to
    # Strip $PYTHON_VERSIONS/$PYTHON_VERSION_PREFIX prefix from line.
    # Sort by version: split by "." then reverse numeric sort for each piece of the version string
    # The first one is the highest
    find "$HELM_VERSIONS" -maxdepth 1 -mindepth 1 -type d -name "$helm_wanted*" \
      | while IFS= read -r line; do echo "${line#${HELM_VERSIONS%/}/${helm_version_prefix}}"; done \
      | sort -t . -k 1,1rn -k 2,2rn -k 3,3rn \
      | head -1
  )"
  reported="${helm_prefix}"
  helm_prefix="${HELM_VERSIONS}/${helm_version_prefix}${helm_prefix}"

  if [ ! -d "$helm_prefix" ]; then
    log_error "Could not find Helm ${helm_version_prefix}${version}. Attempting to download..."
    if install_helm "${version}"; then
      log_status "Installed Helm ${helm_version_prefix}${version} to ${HELM_VERSIONS}!"
    else
      log_error "Unable to install Helm ${helm_version_prefix}${version}"
      return 1
    fi
  fi

  if [ "$reported" != "${version}" ]; then
    log_status "Resolved helm '${version}' -> '$reported'"
  fi
  PATH_add "$helm_prefix"
}
