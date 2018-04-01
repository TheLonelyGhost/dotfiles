# vim: ft=zsh
__hostname=$(uname -n)

# Default actions upon changing directory
chpwd() {
  # only present new directory's ls if in the terminal, not when scripted out
  if [ -t 1 ]; then
    if [ "$__IS_MAC" = "true" ]; then
      ls -GF
    else
      ls -F --color=auto
    fi
  fi
  if [ -e "${HOME}/.keychain/${__hostname}-sh" ]; then
    # Reload env variables for keychain on every change of directory
    . "${HOME}/.keychain/${__hostname}-sh"
  fi
}
