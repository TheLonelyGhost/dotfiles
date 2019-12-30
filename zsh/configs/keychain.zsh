# vim: ft=zsh

if [ -z "${SSH_CONNECTION:-}" ]; then
  # Except when handling incoming SSH connections (you're on your own, in that case)...
  keychain --nogui --quiet --agents 'ssh,gpg'

  # See ~/.zsh/conf/post/chpwd.zsh to see we'll source this file on every change in directory because
  # it's fast and an easy way to keep all the terminal tabs in sync with the latest GPG/SSH agent PIDs
  if [ -e "${HOME}/.keychain/$(uname -n)-sh" ]; then
    . "${HOME}/.keychain/$(uname -n)-sh"
  fi
  if [ -e "${HOME}/.keychain/$(uname -n)-sh-gpg" ]; then
    . "${HOME}/.keychain/$(uname -n)-sh-gpg"
  fi

  export GPG_TTY="$(tty)"

  # We'll let ~/.ssh/config add our ssh keys on-the-fly with `AddKeysToAgent` property
fi
