# modify the prompt to contain git branch name if applicable
git_prompt_info() {
  current_branch=$(git current-branch 2> /dev/null)
  if [[ -n $current_branch ]]; then
    echo " %{$GREEN%}$current_branch%{$NORMAL%}"
  fi
}
setopt promptsubst
PS1='${SSH_CONNECTION+"%{$GREEN%}%n@%m:"}%{$BLUE%}%c%{$NORMAL%}$(git_prompt_info) %# '
