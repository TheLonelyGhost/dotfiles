#!/usr/bin/env bash

# Usage: use java <version>
# Loads specified JDK version.
#
# If you specify a partial JDK version (i.e. `openjdk-16`), a fuzzy match
# is performed and the highest matching version installed is selected.
#
# Environment Variables:
#
# - $JAVA_VERSIONS (required)
#   You must specify a path to your installed JDK versions via the `$JAVA_VERSIONS` variable.
#
# - $JAVA_VERSION_PREFIX (optional)
#   Overrides the default version prefix.
use_java() {
  local version="$1"
  local java_version_prefix=${JAVA_VERSION_PREFIX-}
  local java_prefix

  if [ -z "${JAVA_VERSIONS:-}" ] || [ ! -d "$JAVA_VERSIONS" ]; then
    log_error "You must specify a \$JAVA_VERSIONS environment variable and the directory specified must exist!"
    return 1
  fi

  java_prefix="$(semver_search "${JAVA_VERSIONS}" "${java_version_prefix}" "${version}")"

  if [ ! -x "${JAVA_VERSIONS}/${java_prefix}/bin/javac" ] || [ -z "${java_prefix}" ]; then
    log_error "Could not find JDK ${java_version_prefix}${version}."
    return 1
  fi

  load_prefix "${JAVA_VERSIONS}/${java_prefix}"
  hash -r
  export JAVA_HOME="${JAVA_VERSIONS}/${java_prefix}"
}
