# zstyle ':vcs_info:*' actionformats '%F{5}(%f%s%F{5})%F{3}-%F{5}[%F{2}%b%F{3}|%F{1}%a%F{5}]%f '
# zstyle ':vcs_info:*' formats '%F{5}(%f%s%F{5})%F{3}-%F{5}[%F{2}%b%F{5}]%f '
# zstyle ':vcs_info:(sv[nk]|bzr):*' branchformat '%b%F{1}:%F{3}%r'
zstyle ':vcs_info:git*' formats '%s::(%F{blue}%b%f)%m%c%u'
zstyle ':vcs_info:git*' stagedstr $'%B%F{green}\u2713%f%b'  # green checkmark
zstyle ':vcs_info:git*' unstagedstr $'%B%F{red}\u2717%f%b'  # red ballot 'x'
zstyle ':vcs_info:git*' check-for-changes true
zstyle ':vcs_info:*' enable git

autoload -Uz vcs_info
precmd() { vcs_info }
