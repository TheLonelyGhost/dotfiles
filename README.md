thelonelyghost's dotfiles
=========================

TODO: insert photo preview of dotfiles

Install
-------

1. Install [Homebrew][homebrew] (if on MacOS)
2. Install zsh
3. Install [`rcm`][rcm]
4. Set zsh as your login shell
5. Clone dotfiles
6. Sync (restart terminal session and re-sync, if errors)
7. Restart terminal session

[rcm]: https://github.com/thoughtbot/rcm

### Install Homebrew (MacOS only)

For the most up-to-date docs on how to install homebrew, visit [their homepage][homebrew]. For those too lazy to do that, here's a one-liner that'll probably work for you too.

```bash
$ /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```

### Install ZSH

For MacOS:

```bash
$ brew install zsh
```

For Ubuntu:

```bash
$ sudo apt-get install zsh
```

For Manjaro Linux:

```bash
$ pamac install zsh
```

### Install RCM

For MacOS:

```bash
$ brew tap thoughtbot/formulae
$ brew install rcm
```

For Ubuntu:

```bash
$ sudo add-apt-repository -y ppa:martin-frost/thoughtbot-rcm
$ sudo apt-get install -y rcm
```

For Manjaro Linux:

```bash
$ pamac install rcm
```

### Set ZSH as your login shell

For MacOS:

```bash
$ grep -qFe '/usr/local/bin/zsh' /etc/shells &>/dev/null || echo '/usr/local/bin/zsh' | sudo tee -a /etc/shells 1>/dev/null
$ chsh -s /usr/local/bin/zsh
```

For Ubuntu:

```bash
$ chsh -s "$(command -v zsh)"
```

For Manjaro:

```bash
$ chsh -s "$(command -v zsh)"
```

### Clone dotfiles

```bash
$ git clone https://gitlab.com/thelonelyghost/dotfiles.git ~/.dotfiles
```

(Or, [fork and keep your fork updated](http://robots.thoughtbot.com/keeping-a-github-fork-updated)).


### Sync

```bash
$ env RCRC="${HOME}/.dotfiles/rcrc" rcup
```

After the initial installation, you can run `rcup` without the one-time variable `RCRC` being set (`rcup` will symlink the repo's `rcrc` to `~/.rcrc` for future runs of `rcup`). [See example](https://gitlab.com/thelonelyghost/dotfiles/blob/master/rcrc).

This command will create symlinks for config files in your home directory.  Setting the `RCRC` environment variable tells `rcup` to use standard configuration options:

* Exclude the `README.md` and `LICENSE` files, which are part of the `dotfiles` repository but do not need to be symlinked in.
* Give precedence to personal overrides which by default are placed in `~/.dotfiles-local`
* Detect if MacOS or Linux and sync platform-specific files from the relevant `tag-` directory as well

You can safely run `rcup` multiple times to update:

```bash
$ rcup
```

You should run `rcup` after running `git pull` to finalize any updates, otherwise you risk subsequent shell sessions being broken if files that were previously symlinked in-place are removed by the update. Worst case scenario, no changes to the bash shell are made and you can always set `/bin/bash` as your shell to recover

Specific Usage
--------------

- [Customization](docs/Customization.md)
- [Shell (ZSH)](docs/Shell.md)
- [Terminal (Alacritty)](docs/Terminal.md)
- [Git](docs/Git.md)
- [tmux](docs/Tmux.md)
- [Password Manager (KeePassXC)](docs/PasswordManager.md)
- [Python](docs/Python.md)
- [Ruby](docs/Ruby.md)
- [NodeJS](docs/JavaScript.md)
- [Go](docs/GoLang.md)
- [Docker](docs/Docker.md)
- [Project-specific sandboxing](docs/Direnv.md)

Thanks
------

Thank you, [thoughtbot (and contributors)](https://github.com/thoughtbot/dotfiles/contributors) for initial scaffolding of dotfiles repository.

License
-------

dotfiles is copyright © 2009-2020 thoughtbot and David Alexander. It is free software, and may be redistributed under the terms specified in the [`LICENSE`] file.

[`LICENSE`]: /LICENSE
