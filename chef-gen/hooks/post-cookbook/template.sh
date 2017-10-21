#!/bin/bash

set -e

export OVERCOMMIT_DISABLE=1

INSTALL_PATH="$(realpath "$1")"; shift
COOKBOOK_NAME="$(basename "$INSTALL_PATH")"
TEMPLATE_DIR="${HOME}/.chef-gen/templates/cookbook"

if ! [ -d "$TEMPLATE_DIR" ]; then
  printf 'Template dir ("%s") does not exist\n' "$TEMPLATE_DIR" >&2
  exit 1
fi

# Create directory structure first
find "$TEMPLATE_DIR" -type d | sort | while read -r dir; do
  rel_path="$(echo "$dir" | sed -e 's!'"$TEMPLATE_DIR"'!!g' | sed -e 's!^\.*/!!g')"
  if [ -n "$rel_path" ]; then
    mkdir -p "$rel_path"
  fi
done

printf 'Copying over templates from "%s" to "%s"\n' "$TEMPLATE_DIR" "$INSTALL_PATH"

# Copy over files and do a string replace for the cookbook name, if it is contained
find "$TEMPLATE_DIR" -type f | while read -r file; do
  rel_path="$(echo "$file" | sed -e 's!'"$TEMPLATE_DIR"'!!g' | sed -e 's!^\.*/!!g')"

  printf "Evaluating string replace from '%s' into '%s/%s'\n" "$file" "$INSTALL_PATH" "$rel_path"
  sed -e 's/TPL_COOKBOOK_NAME/'"$COOKBOOK_NAME"'/g' "$file" > "$INSTALL_PATH/$rel_path"
done

# Commit files as "Adds base X configuration"
git add .
git commit -m "Adds base ${COMPANY_NAME:-'(generated)'} configurations"
