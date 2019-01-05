# Load chruby if available
if [ -f "${HOME}/.nix-profile/share/chruby/chruby.sh" ]; then
  source "${HOME}/.nix-profile/share/chruby/chruby.sh"
elif [ -f "/usr/local/share/chruby/chruby.sh" ]; then
  source "/usr/local/share/chruby/chruby.sh"
fi
