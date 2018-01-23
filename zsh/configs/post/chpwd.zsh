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
}
