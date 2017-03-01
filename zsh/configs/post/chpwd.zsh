
# Default actions upon changing directory
function chpwd {
  # only present new directory's ls if in the terminal, not when scripted out
  if [ -t 1 ]; then
    ls
  fi
}

