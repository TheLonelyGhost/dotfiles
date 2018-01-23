# makes color constants available
# autoload -U colors
# colors

BLACK=$(tput setaf 0)
RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
LIME_YELLOW=$(tput setaf 190)
POWDER_BLUE=$(tput setaf 153)
BLUE=$(tput setaf 4)
MAGENTA=$(tput setaf 5)
CYAN=$(tput setaf 6)
WHITE=$(tput setaf 7)
BRIGHT=$(tput bold)
NORMAL=$(tput sgr0)
BLINK=$(tput blink)
REVERSE=$(tput smso)
UNDERLINE=$(tput smul)

# export BLACK RED GREEN YELLOW LIME_YELLOW POWDER_BLUE BLUE MAGENTA CYAN WHITE BRIGHT NORMAL BLINK REVERSE UNDERLINE

# enable colored output from ls, etc. on FreeBSD-based systems
export CLICOLOR=1
