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

# load custom executable functions
for function in ~/.zsh/functions/*; do
  source $function
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

# aliases
[[ -f ~/.aliases ]] && source ~/.aliases || true

unset -f _load_settings
unset -f _profile_source
