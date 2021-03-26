#!/usr/bin/env bash

use_k3d-cluster() {
  local cluster_name
  if [ $# -lt 1 ]; then
    cluster_name='default'
  else
    cluster_name="$1"
  fi

  if ! has k3d; then
    log_error 'Missing k3d. Please install it (e.g., `brew install k3d`) and try again'
    return 1
  fi

  if ! k3d list | grep -qFe "$cluster_name" &>/dev/null; then
    log_error "Missing k3d cluster named '$cluster_name'. Try creating it with \`k3d create '$cluster_name'\` first."
    return 1
  fi

  if ! k3d get-kubeconfig --name="$cluster_name" &>/dev/null; then
    log_status "Waiting for k3d cluster '$cluster_name' to come online"
    until k3d get-kubeconfig --name="$cluster_name" &>/dev/null; do sleep 1; done
  fi
  KUBECONFIG="$(k3d get-kubeconfig --name="$cluster_name")"
  export KUBECONFIG
}

install_kubectl() {
  if [ -z "${KUBECTL_VERSIONS}" ] || [ ! -d "${KUBECTL_VERSIONS}" ]; then
    log_error "You must specify a \$KUBECTL_VERSIONS environment variable and the directory specified must exist!"
    return 1
  fi

  local version="$1"
  local install_dir="${KUBECTL_VERSIONS}/${KUBECTL_VERSION_PREFIX}${version}"
  local GO_OS GO_ARCH

  if [ -z "$version" ]; then
    log_error 'Must specify version of kubectl to install with `install_kubectl`'
    return 1
  fi

  if [ -e "$install_dir" ]; then
    log_status "Found kubectl ${KUBECTL_VERSION_PREFIX}${version} in ${KUBECTL_VERSIONS}"
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

  tmpdir="$(mkdir -p "$(direnv_layout_dir)/tmp" && printf '%s\n' "$(direnv_layout_dir)/tmp")"

  if ! curl -fSLo "${tmpdir}/kubectl" "https://storage.googleapis.com/kubernetes-release/release/v${version}/bin/${GO_OS}/${GO_ARCH}/kubectl"; then
    log_error "Failed to download kubectl ${version}"
    return 1
  fi
  mkdir -p "$install_dir"
  chmod +x "${tmpdir}/kubectl" && mv "${tmpdir}/kubectl" "${install_dir}/kubectl"
}

use_kubectl() {
  local version="$1"
  local kubectl_wanted kubectl_prefix reported

  if [ -z "${KUBECTL_VERSIONS}" ] || [ ! -d "${KUBECTL_VERSIONS}" ]; then
    log_error "You must specify a \$KUBECTL_VERSIONS environment variable and the directory specified must exist!"
    return 1
  fi

  if [ -z "$version" ]; then
    log_error "I do not know which kubectl version to load because one has not been specified!"
    return 1
  fi

  kubectl_wanted="${KUBECTL_VERSION_PREFIX}${version}"
  kubectl_prefix="$(find_version "$KUBECTL_VERSIONS" "$kubectl_wanted" "$KUBECTL_VERSION_PREFIX")"
  reported="${kubectl_prefix}"
  kubectl_prefix="${KUBECTL_VERSIONS}/${KUBECTL_VERSION_PREFIX}${kubectl_prefix}"

  if [ ! -d "$kubectl_prefix" ]; then
    log_error "Could not find kubectl ${KUBECTL_VERSION_PREFIX}${version}. Attempting to download..."
    if install_kubectl "${version}"; then
      log_status "Installed kubectl ${KUBECTL_VERSION_PREFIX}${version} to ${KUBECTL_VERSIONS}!"
    else
      log_error "Unable to install kubectl ${KUBECTL_VERSION_PREFIX}${version}"
      return 1
    fi

    # Try again
    kubectl_prefix="$(find_version "$KUBECTL_VERSIONS" "$kubectl_wanted" "$KUBECTL_VERSION_PREFIX")"
    reported="${kubectl_prefix}"
    kubectl_prefix="${KUBECTL_VERSIONS}/${KUBECTL_VERSION_PREFIX}${kubectl_prefix}"
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
  local install_dir="${HELM_VERSIONS}/${HELM_VERSION_PREFIX}${version}"
  local GO_OS GO_ARCH

  if [ -z "$version" ]; then
    log_error 'Must specify version of helm to install with `install_helm`'
    return 1
  fi

  if [ -e "$install_dir" ]; then
    log_status "Found helm ${HELM_VERSION_PREFIX}${version} in ${HELM_VERSIONS}"
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
  if ! curl -fSLo "${tmpdir}/helm.tgz" "https://get.helm.sh/helm-v${version}-${GO_OS}-${GO_ARCH}.tar.gz"; then
    log_error "Failed to download helm ${version}"
    return 1
  fi
  mkdir -p "$install_dir"
  tar xzf "${tmpdir}/helm.tgz" -C "$install_dir" --strip-components=1
}

use_helm() {
  local version="$1"
  local helm_wanted helm_prefix reported

  if [ -z "${HELM_VERSIONS}" ] || [ ! -d "${HELM_VERSIONS}" ]; then
    log_error "You must specify a \$HELM_VERSIONS environment variable and the directory specified must exist!"
    return 1
  fi

  if [ -z "$version" ]; then
    log_error "I do not know which Helm version to load because one has not been specified!"
    return 1
  fi

  helm_wanted="${HELM_VERSION_PREFIX}${version}"
  helm_prefix="$(find_version "$HELM_VERSIONS" "$helm_wanted" "$HELM_VERSION_PREFIX")"
  reported="${helm_prefix}"
  helm_prefix="${HELM_VERSIONS}/${HELM_VERSION_PREFIX}${helm_prefix}"

  if [ ! -d "$helm_prefix" ]; then
    log_error "Could not find Helm ${HELM_VERSION_PREFIX}${version}. Attempting to download..."
    if install_helm "${version}"; then
      log_status "Installed Helm ${HELM_VERSION_PREFIX}${version} to ${HELM_VERSIONS}!"
    else
      log_error "Unable to install Helm ${HELM_VERSION_PREFIX}${version}"
      return 1
    fi

    # Try again
    helm_prefix="$(find_version "$HELM_VERSIONS" "$helm_wanted" "$HELM_VERSION_PREFIX")"
    reported="${helm_prefix}"
    helm_prefix="${HELM_VERSIONS}/${HELM_VERSION_PREFIX}${helm_prefix}"
  fi

  if [ "$reported" != "${version}" ]; then
    log_status "Resolved helm '${version}' -> '$reported'"
  fi
  PATH_add "$helm_prefix"
}
