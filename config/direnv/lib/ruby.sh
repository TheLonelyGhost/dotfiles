#!/usr/bin/env bash
# shellcheck disable=SC2181

RUBY_VERSION_PREFIX="${RUBY_VERSION_PREFIX-ruby-}"
RUBY_VERSIONS="${RUBY_VERSIONS-"${HOME}/.rubies"}"

# Usage: use ruby
# Loads Ruby version from a `.ruby-version` file.
#
# Usage: use ruby [<version>] [sandboxed]
# Loads specified Ruby version.
#
# If you specify a partial Python version (i.e. `3.2`), a fuzzy match
# is performed and the highest matching version installed is selected.
#
# Environment Variables:
#
# - $RUBY_VERSIONS (required)
#   You must specify a path to your installed Ruby versions via the `$RUBY_VERSIONS` variable.
#
# - $RUBY_VERSION_PREFIX (optional) [default="ruby-"]
#   Overrides the default version prefix.
use_ruby() {
  if [[ "$1" =~ sandbox* ]]; then
    export GEM_PATH=''; shift
  fi
  local version="$1"
  if [[ "${2:-}" =~ sandbox* ]]; then
    export GEM_PATH=''
  fi
  local via=""
  local ruby_version_prefix=${RUBY_VERSION_PREFIX-ruby-}
  local ruby_wanted
  local ruby_prefix
  local reported

  if [ -z "$RUBY_VERSIONS" ] || [ ! -d "$RUBY_VERSIONS" ]; then
    log_error "You must specify a \$RUBY_VERSIONS environment variable and the directory specified must exist!"
    return 1
  fi

  if [ -z "$version" ] && [ -f .ruby-version ]; then
    version=$(<.ruby-version)
    via=".ruby-version"
  fi

  if [ -z "$version" ]; then
    log_error "I do not know which Python version to load because one has not been specified!"
    return 1
  fi

  ruby_wanted="${ruby_version_prefix}${version}"
  ruby_prefix="$(
    # Look for matching python versions in $RUBY_VERSIONS path
    # Strip possible "/" suffix from $RUBY_VERSIONS, then use that to
    # Strip $RUBY_VERSIONS/$RUBY_VERSION_PREFIX prefix from line.
    # Sort by version: split by "." then reverse numeric sort for each piece of the version string
    # The first one is the highest
    find "$RUBY_VERSIONS" -maxdepth 1 -mindepth 1 -type d -name "$ruby_wanted*" \
      | while IFS= read -r line; do echo "${line#${RUBY_VERSIONS%/}/${ruby_version_prefix}}"; done \
      | sort -t . -k 1,1rn -k 2,2rn -k 3,3rn \
      | head -1
  )"

  ruby_prefix="${RUBY_VERSIONS}/${ruby_version_prefix}${ruby_prefix}"

  if [ ! -d "$ruby_prefix" ]; then
    log_error "Unable to find Ruby version ($version) in ($RUBY_VERSIONS)!"
    return 1
  fi

  if [ ! -x "${ruby_prefix}/bin/ruby" ]; then
    log_error "Unable to load Ruby binary (ruby) for version ($version) in ($RUBY_VERSIONS)!"
    return 1
  fi

  load_prefix "$ruby_prefix"
  layout_ruby
  reported="$(ruby -e 'puts RUBY_VERSION')"

  if [ -z "$via" ]; then
    log_status "Successfully loaded Ruby $reported, from prefix ($(user_rel_path "$ruby_prefix"))"
  else
    log_status "Successfully loaded Ruby $reported (via $via), from prefix ($(user_rel_path "$ruby_prefix"))"
  fi
}
