# modify the prompt to contain git branch name if applicable
git_prompt_info() {
  current_branch=$(git current-branch 2> /dev/null)
  if [[ -n $current_branch ]]; then
    echo " %{$GREEN%}$current_branch%{$NORMAL%}"
  fi
}
show_virtual_env_name() {
  if [ -n "${VIRTUAL_ENV:-}" ]; then
    echo "($(basename "${VIRTUAL_ENV}"))"
  fi
}
setopt promptsubst
PS1='$(show_virtual_env_name)${SSH_CONNECTION+"%{$GREEN%}%n@%m:"}%{$BLUE%}%c%{$NORMAL%}$(git_prompt_info) %# '
