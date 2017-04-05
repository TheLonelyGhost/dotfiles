
if ls --color=auto &>/dev/null; then
  export HAS_MAC_LS=false
else
  export HAS_MAC_LS=true
fi

# Default actions upon changing directory
function chpwd {
  # only present new directory's ls if in the terminal, not when scripted out
  if [ -t 1 ]; then
    if $HAS_MAC_LS; then
      ls -GF
    else
      ls -F --color=auto
    fi
  fi
}

