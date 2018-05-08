# vim: ft=zsh
keychain --nogui --quiet --agents 'ssh,gpg'

# See ~/.zsh/conf/post/chpwd.zsh to see we'll source this file on every change in directory because
# it's fast and an easy way to keep all the terminal tabs in sync with the latest GPG/SSH agent PIDs
if [ -e "${HOME}/.keychain/$(uname -n)-sh" ]; then
  . "${HOME}/.keychain/$(uname -n)-sh"
fi
if [ -e "${HOME}/.keychain/$(uname -n)-sh-gpg" ]; then
  . "${HOME}/.keychain/$(uname -n)-sh-gpg"
fi

# Read prior TTY to GPG_TTY var
if [ -e "${HOME}/.config/gpg-tty" ]; then
  GPG_TTY="$(cat "${HOME}/.config/gpg-tty")"
fi
# Spawn new TTY for GPG key pinentry
if [ -z "${GPG_TTY:-}" ] || [ ! -e "${GPG_TTY:-}" ]; then
  GPG_TTY="$(tty)"
fi
# Persist the TTY to central file location, only if changed
if [ -n "${GPG_TTY:-}" ] && [ "$(cat "${HOME}/.config/gpg-tty" 2>/dev/null)" != "${GPG_TTY:-}" ]; then
  printf '%s\n' "${GPG_TTY}" > "${HOME}/.config/gpg-tty"
fi

export GPG_TTY

# Uncomment if you want to add all of the SSH keys matching ~/.ssh/*id_rsa on every login
# Instead, we'll let ~/.ssh/config add it on-the-fly with `AddKeysToAgent` Hosts property
# if command -v add-all-ssh-keys &>/dev/null; then add-all-ssh-keys; fi
