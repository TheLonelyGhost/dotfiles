SHELLCHECK_OPTS='-e SC1090 -e SC1091 -e SC2088 -e SC2016 -e1117'
PYENV_ROOT="${HOME}/.pyenv"
TAG_SEARCH_PROG='rg'

if [ -z "${MANPATH:-}" ]; then
  # Ensure the manpath is set
  MANPATH="`manpath`"
fi

typeset -UT MANPATH manpath
typeset -UT GOPATH gopath
typeset -UT NODE_PATH nodepath

NPM_PACKAGES="${HOME}/.npm-packages"

gopath=("${HOME}/.go" $gopath)
nodepath=("${NPM_PACKAGES}/lib/node_modules" $nodepath)
manpath=("${NPM_PACKAGES}/share/man" $manpath)

path=(
  "${HOME}/.hashi-env/bin"
  "${NPM_PACKAGES}/bin"
  # "${PYENV_ROOT}/bin"
  "${GOPATH}/bin"
  "${HOME}/.cargo/bin"
  # "${HOME}/.nodenv/shims"
  # "${HOME}/.nodenv/bin"
  /usr/local/sbin
  $path)

if [ -d /usr/local/heroku/bin ]; then
  path+=/usr/local/heroku/bin
fi

if [ -d /usr/local/go/bin ]; then
  path+=/usr/local/go/bin
fi

if [ -d /usr/local/opt/libressl/bin ]; then
  # We want this earlier than the default `openssl` bin
  path=(
    /usr/local/opt/libressl/bin
    $path)
fi

# if [ -e "${HOME}/.cargo/env" ]; then
#   source "${HOME}/.cargo/env"
# fi

if [ -e "${HOME}/.nix-profile" ]; then
  path=(
    "${HOME}/.nix-helpers/bin"
    $path)
fi

# Local config
if [ -e "${HOME}/.zshenv.local" ]; then source "${HOME}/.zshenv.local"; fi
if [ -e "${HOME}/.path" ]; then source "${HOME}/.path"; fi
if [ -e "${HOME}/.path.local" ]; then source "${HOME}/.path.local"; fi

# Ensure ~/.local/bin/ is where we try to put things we care about
# But favor what we put in-place with our own automation more (~/.bin)
path=(
  "${HOME}/.bin"
  "${HOME}/.local/bin"
  $path)

if [ -f "${HOME}/.aliases" ]; then . "${HOME}/.aliases"; fi
if [ -f "${HOME}/.aliases.local" ]; then . "${HOME}/.aliases.local"; fi

export PYENV_ROOT NPM_PACKAGES SHELLCHECK_OPTS TAG_SEARCH_PROG GOPATH MANPATH NODE_PATH
