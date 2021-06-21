zmodload zsh/zprof

if [ -e "${HOME}/.zplug/init.zsh" ]; then
  source ~/.zplug/init.zsh
  zplug 'zplug/zplug', hook-build:'zplug --self-manage'
  if [ -f "${HOME}/.zplugins" ]; then
    source "${HOME}/.zplugins"
  fi

  if ! zplug check; then
      printf "Install missing zplug plugins? [y/N]: "
      if read -q; then
          echo; zplug install
      fi
  fi
  zplug load
else
  printf 'WARNING! %s\n' "Could not find \`~/.zplug/init.zsh'. No zplug plugins will be active" 1>&2
fi

# load custom executable functions
fpath=(
  "${HOME}/.zsh/functions"
  $fpath
)
for function in ~/.zsh/functions/*; do
  func="$(basename -- "$function")"
  autoload -Uz "$func"
done

# extra files in ~/.zsh/configs/pre , ~/.zsh/configs , and ~/.zsh/configs/post
# these are loaded first, second, and third, respectively.
_load_settings() {
  local _dir="$1"
  if [ -d "$_dir" ]; then
    if [ -d "$_dir/pre" ]; then
      for config in "$_dir"/pre/**/*(N-.); do
        source $config
      done
    fi

    for config in "$_dir"/**/*(N-.); do
      case "$config" in
        "$_dir"/pre/*)
          :
          ;;
        "$_dir"/post/*)
          :
          ;;
        *)
          if [ -f $config ]; then
            source $config
          fi
          ;;
      esac
    done

    if [ -d "$_dir/post" ]; then
      for config in "$_dir"/post/**/*(N-.); do
        source $config
      done
    fi
  fi
}
_load_settings "$HOME/.zsh/configs"

# Local config
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local || true

unset -f _load_settings
