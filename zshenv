# vim: ft=zsh
local _old_path="$PATH"

SHELLCHECK_OPTS="-e SC1090 -e SC2088"
WORKON_HOME="${HOME}/.virtualenvs"
PROJECT_HOME="${HOME}/workspace"
VIRTUALENVWRAPPER_VIRTUALENV_ARGS='--no-site-packages'
VIRTUALENVWRAPPER_TMPDIR='/tmp/virtualenvwrapper'
if [ ! -n "${VIRTUALENVWRAPPER_TMPDIR}" ] && [ ! -d "${VIRTUALENVWRAPPER_TMPDIR}" ]; then
  mkdir -p "${VIRTUALENVWRAPPER_TMPDIR}"
fi

# Local config
[[ -f ~/.zshenv.local ]] && source ~/.zshenv.local || true

if [[ "$PATH" != "$_old_path" ]]; then
  # `colors` isn't initialized yet, so define a few manually
  typeset -AHg fg fg_bold
  if [ -t 2 ]; then
    fg[red]=$'\e[31m'
    fg_bold[white]=$'\e[1;37m'
    reset_color=$'\e[m'
  else
    fg[red]=""
    fg_bold[white]=""
    reset_color=""
  fi

  cat <<MSG >&2
${fg[red]}Warning:${reset_color} your \`~/.zshenv.local' configuration seems to edit PATH entries.
Please move that configuration to \`.path.local' like so:
  ${fg_bold[white]}cat ~/.zshenv.local >> ~/.path.local && rm ~/.zshenv.local${reset_color}

(called from ${(%):-%N:%i})

MSG
fi

unset _old_path

export WORKON_HOME PROJECT_HOME VIRTUALENVWRAPPER_VIRTUALENV_ARGS VIRTUALENVWRAPPER_TMPDIR SHELLCHECK_OPTS
