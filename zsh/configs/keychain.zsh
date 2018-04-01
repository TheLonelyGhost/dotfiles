# vim: ft=zsh
find "${HOME}/.ssh" -type f -iname '*id_rsa' -print0 | xargs -0 -I{} keychain --nogui --quiet --agents 'ssh,gpg' {}

# See ~/.zsh/conf/post/chpwd.zsh to see we'll source this file on every change in directory because
# it's fast and an easy way to keep all the terminal tabs in sync with the latest GPG/SSH agent PIDs
if [ -e "${HOME}/.keychain/$(uname -n)-sh" ]; then
  . "${HOME}/.keychain/$(uname -n)-sh"
fi
