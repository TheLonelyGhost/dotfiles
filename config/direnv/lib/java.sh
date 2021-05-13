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

  mkdir -p .git/info
  touch .git/info/exclude

  for pattern in '*.jar' 'target/' '*.class'; do
    if ! grep -qFe "$pattern" ./.git/info/exclude; then
      log_status "Excluding $pattern from accidental commits"
      printf '%s\n' "$pattern" >> ./.git/info/exclude
    fi
  done

  if [ "$(find . \( -path '*/.git/*' -prune \) -a -name 'pom.xml' -print | wc -l)" -gt 0 ] && has mvn; then
    if ! [ -x ./mvnw ]; then
      log_status 'Adding maven wrapper'
      mvn -N io.takari:maven:wrapper 1>/dev/null 2>&1
    fi

    if ! [ -x "$(direnv_layout_dir)/bin/mvn" ] && [ -x ./mvnw ]; then
      log_status "Linking \`mvn' command to wrapper script"
      mkdir -p "$(direnv_layout_dir)/bin"
      ln -s "$(pwd)/mvnw" "$(direnv_layout_dir)/bin/mvn"
      path_add PATH "$(direnv_layout_dir)/bin"
    fi 
  fi

  if [ "$(find . \( -path '*/.git/*' -prune \) -a \( -name '*.gradle' -o -name '*.gradle.*' \) -print | wc -l)" -gt 0 ] && has gradle; then
    if ! [ -x ./gradlew ]; then
      gradle wrapper
    fi

    if ! [ -x "$(direnv_layout_dir)/bin/gradle" ]; then
      log_status "Linking \`gradle' command to wrapper script"
      mkdir -p "$(direnv_layout_dir)/bin"
      ln -s "$(pwd)/gradlew" "$(direnv_layout_dir)/bin/gradle"
      path_add PATH "$(direnv_layout_dir)/bin"
    fi
  fi
}
