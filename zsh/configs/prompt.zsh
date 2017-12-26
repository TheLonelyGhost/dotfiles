# modify the prompt to contain git branch name if applicable
join_by() { local IFS="$1"; shift; echo "$*"; }
git_prompt_info() {
  current_branch=$(git current-branch 2> /dev/null)
  if [[ -n $current_branch ]]; then
    echo " %{$GREEN%}$current_branch%{$NORMAL%}"
  fi
}
show_prefix_name() {
  local out=()
  if [ -n "${VIRTUAL_ENV:-}" ]; then
    out+="$(basename "${VIRTUAL_ENV}")"
  elif [ -n "${RUBY_VERSION:-}" ]; then
    out+="${RUBY_ENGINE:-ruby}-${RUBY_VERSION}"
  fi

  if [ "${#out}" -gt 0 ]; then
    echo "($(join_by , "${out[@]}"))"
  fi
}

setopt promptsubst
PS1='$(show_prefix_name)${SSH_CONNECTION+"%{$GREEN%}%n@%m:"}%{$BLUE%}%c%{$NORMAL%}$(git_prompt_info) %# '
