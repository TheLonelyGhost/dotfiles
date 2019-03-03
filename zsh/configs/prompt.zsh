# modify the prompt to contain git branch name if applicable
# git_prompt_info() {
#   current_branch=$(git current-branch 2> /dev/null)
#   if [ -n "$current_branch" ]; then
#     echo " %{$GREEN%}$current_branch%{$NORMAL%}"
#   fi
# }

fpath=("${HOME}/.zsh/themes" $fpath)
setopt promptsubst
autoload -U vcs_info
autoload -Uz promptinit

zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git:default:*' check-for-changes true

zstyle ':vcs_info:git:default:*' formats '%s::(%c%{'"$GREEN"'%}%b%{'"$NORMAL"'%}%u)'
zstyle ':vcs_info:git:default:*' stagedstr '%{'"$BRIGHT$YELLOW"'%}^%{'"$NORMAL"'%}'
zstyle ':vcs_info:git:default:*' unstagedstr '%{'"$BRIGHT$BLUE"'%}*%{'"$NORMAL"'%}'

# Coffee cup emoji: 'staged'
# zstyle ':vcs_info:git:default:*' stagedstr "$(printf ' %b\n' "\U2615")"
# "No" sign emoji: 'unstaged'
# zstyle ':vcs_info:git:default:*' unstagedstr "$(printf ' %b\n' "\U1F6AB")"

promptinit
precmd() { # Hook for us to get the version control info in the prompt
  vcs_info
}

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
