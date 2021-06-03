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
  #local via=""
  local python_version_prefix=${PYTHON_VERSION_PREFIX-cpython-v}
  local python_prefix

  if [ -z "${PYTHON_VERSIONS:-}" ] || [ ! -d "$PYTHON_VERSIONS" ]; then
    log_error "You must specify a \$PYTHON_VERSIONS environment variable and the directory specified must exist!"
    return 1
  fi

  if [ -z "$version" ] && [ -f .python-version ]; then
    version=$(<.python-version)
    # via=".python-version"
  fi

  if [ -z "$version" ]; then
    log_error "I do not know which Python version to load because one has not been specified!"
    return 1
  fi

  python_prefix="$(semver_search "${PYTHON_VERSIONS}" "${python_version_prefix}" "${version}")"

  if [ ! -x "${PYTHON_VERSIONS}/${python_prefix}/bin/python" ] || [ -z "${python_prefix}" ]; then
    log_error "Could not find python ${python_version_prefix}${version}."
    return 1
  fi

  load_prefix "${PYTHON_VERSIONS}/${python_prefix}"
  hash -r
  layout_python "${PYTHON_VERSIONS}/${python_prefix}/bin/python"

  if [ -x "${VIRTUAL_ENV?}/bin/python3" ]; then
    if ! [ -e "${VIRTUAL_ENV?}/bin/pip" ]; then
      printf '#!/usr/bin/env sh\npython3 -m pip $@\n' > "${VIRTUAL_ENV}/bin/pip"
      chmod +x "${VIRTUAL_ENV?}/bin/pip"
    fi
    if ! [ -e "${VIRTUAL_ENV?}/bin/pip3" ]; then
      printf '#!/usr/bin/env sh\npython3 -m pip $@\n' > "${VIRTUAL_ENV}/bin/pip3"
      chmod +x "${VIRTUAL_ENV?}/bin/pip3"
    fi
    hash -r
  fi

  #local reported="$(python -c 'import platform as p; import sys; sys.stdout.write(p.python_version())')"
  #if [ -z "$via" ]; then
  #  log_status "Successfully loaded Python $reported, from prefix ($(user_rel_path "${PYTHON_VERSIONS}/${python_prefix}"))"
  #else
  #  log_status "Successfully loaded Python $reported (via $via), from prefix ($(user_rel_path "${PYTHON_VERSIONS}/${python_prefix}"))"
  #fi

  mkdir -p .git/info
  touch .git/info/exclude

  for pattern in '*.pyc' '*.pyo' '*.pyd' '.eggs/' '*.egg' 'pip-wheel-metadata/' '__pycache__' '*.egg-info' '.mypy_cache/'; do
    if grep -qFe "$pattern" .git/info/exclude; then
      log_status "Excluding $pattern from accidental commits"
      printf '%s\n' "$pattern" >> .git/info/exclude
    fi
  done
}
