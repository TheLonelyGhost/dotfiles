__IS_MAC=${__IS_MAC:-$(test "$(uname -s)" = "Darwin" && echo 'true')}

export __IS_MAC
