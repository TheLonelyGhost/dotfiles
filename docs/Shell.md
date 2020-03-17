# Z Shell (ZSH)

Additional `zsh` configuration can go under the `~/.zsh/configs` directory. This has two special subdirectories: `pre` for files that must be loaded first, and `post` for files that must be loaded last.

For example, scripts might use various shell features which may be affected by your settings, so they should be loaded it first by being placed in `~/.zsh/configs/pre/`. One example might be working with `virtualenvwrapper`:

```zsh
# Load the virtualenv wrapper
. /usr/local/bin/virtualenvwrapper.sh
```

Setting a key binding can happen in `~/.zsh/configs/keybindings.zsh`:

```zsh
# Grep anywhere with ^G
bindkey -s '^G' ' | grep '
```

Some changes, like the ZSH-specific hook called when changing directory (`chpwd`), must happen in `~/.zsh/configs/post/chpwd.zsh`:

```zsh
# Show the entries in a directory whenever you cd in
function chpwd {
  ls
}
```

This directory is handy for combining dotfiles from multiple teams; one team can add the `virtualenv` file, another `keybindings`, and a third `chpwd`.

While there is a `~/.zshrc.local` file that is observed, it is deprecated and loaded after `~/.zsh/configs`. Instead, sync a file per group of settings into the `~/.zsh/config/` directory.
