#!/usr/bin/env bash
# shellcheck disable=SC2181

# Usage: use ruby
# Loads Ruby version from a `.ruby-version` file.
#
# Usage: use ruby [<version>] [sandboxed]
# Loads specified Ruby version.
#
# If you specify a partial Ruby version (i.e. `2.2`), a fuzzy match
# is performed and the highest matching version installed is selected.
#
# Environment Variables:
#
# - $RUBY_VERSIONS (required)
#   You must specify a path to your installed Ruby versions via the `$RUBY_VERSIONS` variable.
#
# - $RUBY_VERSION_PREFIX (optional) [default=""]
#   Overrides the default version prefix.
use_ruby() {
  if [[ "$1" =~ sandbox* ]]; then
    export GEM_PATH=''; shift
  fi
  local version="$1"
  if [[ "${2:-}" =~ sandbox* ]]; then
    export GEM_PATH=''
  fi
  # local via=""
  local ruby_version_prefix=${RUBY_VERSION_PREFIX-ruby-}
  local ruby_prefix
  # local reported

  if [ -z "$RUBY_VERSIONS" ] || [ ! -d "$RUBY_VERSIONS" ]; then
    log_error "You must specify a \$RUBY_VERSIONS environment variable and the directory specified must exist!"
    return 1
  fi

  if [ -z "$version" ] && [ -f .ruby-version ]; then
    version=$(<.ruby-version)
    # via=".ruby-version"
  fi

  if [ -z "$version" ]; then
    log_error "I do not know which Python version to load because one has not been specified!"
    return 1
  fi

  ruby_prefix="$(semver_search "${RUBY_VERSIONS}" "${ruby_version_prefix}" "${version}")"

  if [ ! -x "${RUBY_VERSIONS}/${ruby_prefix}/bin/ruby" ] || [ -z "${ruby_prefix}" ]; then
    log_error "Unable to find ruby ${ruby_version_prefix}${version}."
    return 1
  fi

  load_prefix "${RUBY_VERSIONS}/${ruby_prefix}"
  hash -r
  layout_ruby

  # reported="$(ruby -e 'puts RUBY_VERSION')"
  # if [ -z "$via" ]; then
  #   log_status "Successfully loaded Ruby $reported, from prefix ($(user_rel_path "$ruby_prefix"))"
  # else
  #   log_status "Successfully loaded Ruby $reported (via $via), from prefix ($(user_rel_path "$ruby_prefix"))"
  # fi
}
