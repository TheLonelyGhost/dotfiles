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

# Default actions upon changing directory
function chpwd {
  if [ -t 1 ]; then
    ls --color=auto
  fi
}

# tmux has known issues with running this each time it opens a new buffer,
# which is bad because we end up running multiple ssh agents simultaneously.
# The following check on `$TMUX' helps filter it out so it's only run on a new
# non-tmux session instead of every new tmux buffer.
# 
# One ssh agent to rule them all!
if [ -z "$TMUX" ]; then
  # Setup SSH key password in-memory caching
  if [ -z "$SSH_AGENT_PID" ] || [ -z "$(ps --pid $SSH_AGENT_PID &>/dev/null)" ]; then
    eval "$(ssh-agent)"
  fi
fi

# Local config
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local || true

# aliases
[[ -f ~/.aliases ]] && source ~/.aliases || true
