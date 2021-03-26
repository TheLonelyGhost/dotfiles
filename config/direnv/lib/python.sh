#!/usr/bin/env bash

# Usage: use python
# Loads Python version from a `.python-version` file.
#
# Usage: use python <version>
# Loads specified Python version.
#
# If you specify a partial Python version (i.e. `3.2`), a fuzzy match
# is performed and the highest matching version installed is selected.
#
# Environment Variables:
#
# - $PYTHON_VERSIONS (required)
#   You must specify a path to your installed Python versions via the `$PYTHON_VERSIONS` variable.
#
# - $PYTHON_VERSION_PREFIX (optional) [default="cpython-v"]
#   Overrides the default version prefix.
use_python() {
  local version="$1"
  local via=""
  local python_version_prefix=${PYTHON_VERSION_PREFIX-cpython-v}
  local python_wanted
  local python_prefix
  local reported

  if [ -z "$PYTHON_VERSIONS" ] || [ ! -d "$PYTHON_VERSIONS" ]; then
    log_error "You must specify a \$PYTHON_VERSIONS environment variable and the directory specified must exist!"
    return 1
  fi

  if [ -z "$version" ] && [ -f .python-version ]; then
    version=$(<.python-version)
    via=".python-version"
  fi

  if [ -z "$version" ]; then
    log_error "I do not know which Python version to load because one has not been specified!"
    return 1
  fi

  python_wanted="${python_version_prefix}${version}"
  python_prefix="$(
    # Look for matching python versions in $PYTHON_VERSIONS path
    # Strip possible "/" suffix from $PYTHON_VERSIONS, then use that to
    # Strip $PYTHON_VERSIONS/$PYTHON_VERSION_PREFIX prefix from line.
    # Sort by version: split by "." then reverse numeric sort for each piece of the version string
    # The first one is the highest
    find "$PYTHON_VERSIONS" -maxdepth 1 -mindepth 1 -type d -name "$python_wanted*" \
      | while IFS= read -r line; do echo "${line#${PYTHON_VERSIONS%/}/${python_version_prefix}}"; done \
      | sort -t . -k 1,1rn -k 2,2rn -k 3,3rn \
      | head -1
  )"

  python_prefix="${PYTHON_VERSIONS}/${python_version_prefix}${python_prefix}"

  if [ ! -d "$python_prefix" ]; then
    log_error "Unable to find Python version ($version) in ($PYTHON_VERSIONS)!"
    return 1
  fi

  if [ ! -x "${python_prefix}/bin/python" ]; then
    log_error "Unable to load Python binary (python) for version ($version) in ($PYTHON_VERSIONS)!"
    return 1
  fi

  load_prefix "$python_prefix"
  layout_python "${python_prefix}/bin/python"
  reported="$(python -c 'import platform as p; import sys; sys.stdout.write(p.python_version())')"

  if [ -z "$via" ]; then
    log_status "Successfully loaded Python $reported, from prefix ($(user_rel_path "$python_prefix"))"
  else
    log_status "Successfully loaded Python $reported (via $via), from prefix ($(user_rel_path "$python_prefix"))"
  fi
}
