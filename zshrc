_profile_source() {
  # This is a tool to help profile what file being loaded is taking the longest to load. To use this,
  # just run this followed by opening a new terminal:
  #
  #   awk -f ~/.dotfiles/hooks/profile_source.awk ~/.zshrc > ~/.foo.sh
  #   mv ~/.zshrc{,.bak}
  #   echo 'source ~/.foo.sh | sort -k1 -n' > ~/.zshrc
  #
  # To revert to the previous state, run this and reopen your terminal session:
  #
  #   mv ~/.zshrc{.bak,}
  #   rm -f ~/.foo.sh
  #
  local prev after
  prev="$(date +%N)"
  source "$1"
  after="$(date +%N)"
  printf '%011d\t%s\n' "$(($after - $prev))" "${1/${HOME}/~}"
}

if [ -e "${HOME}/.zplug/init.zsh" ]; then
  source ~/.zplug/init.zsh
  zplug 'zplug/zplug', hook-build:'zplug --self-manage'
  [ -f "${HOME}/.zplugins" ] && source "${HOME}/.zplugins" || true

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

unset -f _load_settings _profile_source
