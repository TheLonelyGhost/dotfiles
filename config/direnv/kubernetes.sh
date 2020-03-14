#!/usr/bin/env bash
# shellcheck disable=SC2181

KUBECTL_VERSIONS="${KUBECTL_VERSIONS-${HOME}/.kubectl-versions}"
HELM_VERSIONS="${HELM_VERSIONS-${HOME}/.helm-versions}"

use_kubectx() {
  # Ensure our main kubeconfig is in the mix. If not set, it is
  # anyway, so this makes it easier to shovel in other configs of
  # higher priority
  KUBECONFIG="${KUBECONFIG:-${HOME}/.kube/config}"

  local kube_dir kube_config context
  context="$1"
  kube_dir="$(direnv_layout_dir)/kube"
  mkdir -p "$kube_dir"

  # This is the default config for the directory, where we'll modify
  # project-specific configs for kubernetes
  touch "${kube_dir}/config"
  path_add "KUBECONFIG" "${kube_dir}/config"

  # This must come last so we can make sure switching contexts with
  # direnv is simple and easy, leaning heavily on kubectl's overlay
  # feature for multiple kubeconfig files (where first definition of
  # something is the authoritative configuration)
  printf 'current-context: %s\n' "${context}" > "${kube_dir}/context"
  path_add "KUBECONFIG" "${kube_dir}/context"

  export KUBECONFIG
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
    log_error "I do not know which Python version to load because one has not been specified!"
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
    log_error "I do not know which Python version to load because one has not been specified!"
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
    log_error "Unable to load Helm binary (helm) for version (${version}) in (${HELM_VERSIONS})!"
    return 1
  fi

  if [ "$reported" != "${version}" ]; then
    log_status "Resolved helm '${version}' -> '$reported'"
  fi
  PATH_add "$helm_prefix"
}
