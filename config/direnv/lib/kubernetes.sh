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

use_kubectl() {
  local version
  local kubectl_wanted kubectl_prefix
  # local reported

  if [ -z "${KUBECTL_VERSIONS:-}" ] || [ ! -d "${KUBECTL_VERSIONS}" ]; then
    log_error "You must specify a \$KUBECTL_VERSIONS environment variable and the directory specified must exist!"
    return 1
  fi

  version="${1:-}"
  if [ -z "$version" ]; then
    log_error "I do not know which kubectl version to load because one has not been specified!"
    return 1
  fi

  kubectl_wanted="${KUBECTL_VERSION_PREFIX}${version}"
  kubectl_prefix="$(semver_search "$KUBECTL_VERSIONS" "$KUBECTL_VERSION_PREFIX" "$kubectl_wanted")"

  if [ ! -d "${KUBECTL_VERSIONS}/${kubectl_prefix}" ] || [ -z "${kubectl_prefix}" ]; then
    log_error "Could not find kubectl ${KUBECTL_VERSION_PREFIX}${version}."
    return 1
  fi

  #local reported="${kubectl_prefix}"
  #if [ "$reported" != "${version}" ]; then
  #  log_status "Resolved kubectl '${version}' -> '$reported'"
  #fi
  load_prefix "${KUBECTL_VERSIONS}/${kubectl_prefix}"
  hash -r
}

use_helm() {
  local version helm_wanted helm_prefix

  if [ -z "${HELM_VERSIONS}" ] || [ ! -d "${HELM_VERSIONS}" ]; then
    log_error "You must specify a \$HELM_VERSIONS environment variable and the directory specified must exist!"
    return 1
  fi

  version="${1:-}"
  if [ -z "$version" ]; then
    log_error "I do not know which Helm version to load because one has not been specified!"
    return 1
  fi

  helm_wanted="${HELM_VERSION_PREFIX}${version}"
  helm_prefix="$(semver_search "$HELM_VERSIONS" "$HELM_VERSION_PREFIX" "$helm_wanted")"

  if [ ! -d "${HELM_VERSIONS}/${helm_prefix}" ] || [ -z "${helm_prefix}" ]; then
    log_error "Could not find Helm ${HELM_VERSION_PREFIX}${version}."
    return 1
  fi

  #local reported="${helm_prefix}"
  #if [ "$reported" != "${version}" ]; then
  #  log_status "Resolved helm '${version}' -> '$reported'"
  #fi
  load_prefix "${HELM_VERSIONS}/${helm_prefix}"
  hash -r
}
