# modify the prompt to contain git branch name if applicable
# git_prompt_info() {
#   current_branch=$(git current-branch 2> /dev/null)
#   if [ -n "$current_branch" ]; then
#     echo " %{$GREEN%}$current_branch%{$NORMAL%}"
#   fi
# }

fpath=("${HOME}/.zsh/themes" $fpath)
setopt promptsubst
autoload -Uz promptinit

promptinit

# set our prompt info
prompt thelonelyghost

# shell functions that should exist for the PROMPT
__show-prefix() {
  local IFS out
  out=()

  if [ -n "${VIRTUAL_ENV:-}" ] && [ "${PIPENV_ACTIVE:-}" -ne '1' ]; then
    out+="$(basename "${VIRTUAL_ENV}")"
  fi
  if [ -n "${RUBY_VERSION:-}" ]; then
    out+="${RUBY_ENGINE:-ruby}-${RUBY_VERSION}"
  fi

  if [ "${#out}" -gt 0 ]; then
    IFS='|'
    printf '(%s) \n' "${out[*]}"
  fi
}

# This is a lighter-weight version of what vcs_info already provides
git_prompt_info() {
  local current_branch dirty_indicator staged_indicator ret empty_tree_sha HEAD
  dirty_indicator=''
  staged_indicator=''
  empty_tree_sha='4b825dc642cb6eb9a060e54bf8d69288fbee4904'
  current_branch=$(git current-branch 2> /dev/null)
  if [ -n "$current_branch" ]; then
    if ! git diff --no-ext-diff --ignore-submodules=dirty --quiet --exit-code 2> /dev/null; then
			# YEP! We have some tracked, but unstaged changes!
      dirty_indicator=' %{'"$BRIGHT$RED"'%}✗%{'"$NORMAL"'%}'
    fi
    if git rev-parse --quiet --verify HEAD &> /dev/null; then
      # Repo exists
			HEAD='HEAD'
    else
      # Empty repo (no commits
			HEAD="${empty_tree_sha}"
    fi

		ret=$(git diff-index --cached --quiet --ignore-submodules=dirty HEAD 2> /dev/null || echo $?)
		if [ "$ret" -ne 128 ] && [ "$ret" -ne 0 ]; then
			# YEP! We have some staged changes!
			staged_indicator=' %{'"$BRIGHT$GREEN"'%}✔%{'"$NORMAL"'%}'
		fi

    printf 'git::(%b%s%b)%b%b\n' "%{${BLUE}%}" "$current_branch" "%{$NORMAL%}" "${staged_indicator}" "${dirty_indicator}"
  fi
}
