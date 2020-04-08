fpath=(/usr/local/share/zsh/site-functions $fpath)

# Use GNU coreutils unprefixed
PATH="/usr/local/opt/coreutils/libexec/gnubin:${PATH}"
MANPATH="/usr/local/opt/coreutils/gnuman:${MANPATH}"

# Use GNU make unprefixed
PATH="/usr/local/opt/make/libexec/gnubin:${PATH}"
MANPATH="/usr/local/opt/make/gnuman:${MANPATH}"

export SSL_CERT_FILE='/usr/local/etc/openssl/cert.pem'

alias brew='env PYENV_VERSION=system brew'
