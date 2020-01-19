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

### Clone dotfiles

```bash
$ git clone git://gitlab.com/thelonelyghost/dotfiles.git ~/.dotfiles
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
* Detect if MacOS or Linux and sync files from the, e.g., `tag-linux` directory as well
* Copy the templates for new git repositories instead of referencing one canonical location for all repositories

You can safely run `rcup` multiple times to update:

```bash
$ rcup
```

You should run `rcup` after pulling a new version of the repository to symlink any new files in the repository.

Make your own customizations
----------------------------

Put your customizations in dotfiles appended with `.local`:

* `~/.aliases.local`
* `~/.gitconfig.local`
* `~/.psqlrc.local` (we supply a blank `.psqlrc.local` to prevent `psql` from throwing an error, but you should overwrite the file with your own copy)
* `~/.tmux.conf.local`
* `~/.config/nvim/bundles.vim.local`

For example, your `~/.aliases.local` might look like this:

```bash
# Productivity
alias todo='$EDITOR ~/.todo'
```

Your `~/.gitconfig.local` might look like this:

```config
[alias]
  l = log --pretty=colored
[pretty]
  colored = format:%Cred%h%Creset %s %Cgreen(%cr) %C(bold blue)%an%Creset
[user]
  name = David Alexander
  email = myname@example.com
```

Your `~/.config/nvim/bundles.vim.local` might look like this:

```vim
Plug 'Lokaltog/vim-powerline'
Plug 'stephenmckinney/vim-solarized-powerline'
```

`zsh` Configurations
--------------------

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

NeoVim Configurations
---------------------

Similarly to the `zsh` configuration directory as described above, neovim automatically loads all files in the `~/.config/nvim/plugin` directory. This does not have the same `pre` or `post` subdirectory support that our `zshrc` has.

This is an example `~/.config/nvim/plugin/c.vim`. It is loaded every time vim starts, regardless of the file name:

```vim
# Indent C programs according to BSD style(9)
set cinoptions=:0,t0,+4,(4
autocmd BufNewFile,BufRead *.[ch] setlocal sw=0 ts=8 noet
```

For any customizations you would put in your `vimrc` (or `init.vim` for NeoVim), instead sync them to the `~/.config/nvim/plugin/` directory as one file per grouping of settings

What's in it?
-------------

System packages:

* Manager: `apt-get` (Ubuntu) - `hooks/packages/apt`
* Manager: [`homebrew`][homebrew] (MacOS) - `hooks/packages/brew`
* Manager: [`gem`][rubygems] (Ruby) - `hooks/packages/rubygems`
* Manager: [`npm`][npm] (Node) - `hooks/packages/npm`
* Manager: [`go get`][go-lang] (Go) - `hooks/packages/go`
* Manager: [`pip`][pip] (Python) - `hooks/packages/pip`
* Manager: [`vim-plug`][vim-plug] (NeoVim) - `config/nvim/bundle.vim` (OPTIONAL: also `~/.config/nvim/bundles.vim.local`)
* Feature: Cache updating package manager, because network latency is expensive
* Feature: `npm` installs to directory in user space, so no `sudo` is required for global installs
* Feature: `gem` installs to directory in user space, so no `sudo` is required for install

Here are the software choices and why they were chosen:

* Terminal: [Alacritty][alacritty]
  * because it's _really fast_
  * because it has consistent, cross-platform support
  * because it has better support for unicode than most alternatives
  * because `tmux` is already good at handling scrollback, tabs, etc.
* Password Manager: [KeePassXC][keepassxc]
  * because autotype keyboard emulation is _really nice_
  * because it supports a lot of customization of encryption settings (useful as vulnerabilities are discovered)
  * because we can self-host it anywhere we want
  * because the vault's file format is portable ([Android][keepass-android] and [iOS][keepass-ios] apps are available)
  * because syncing with cloud storage providers is specifically [out of scope][keepassxc-cloud-syncing]
  * because we can control _when_ we sync the data (backed by [`rclone`][rclone])
* Editor: [NeoVim][neovim]
  * because it's a _text editor_, not an IDE (vim vs. *)
    * most IDEs seem to have issues that pop up when people assume the execution environment is the same between the shell and the IDE
    * IDEs can be bloated and include features you will never use, whereas vim/neovim only keep things super lightweight
    * IDEs have their niceties, but NeoVim allows us to build our own from more robust shell commands
  * (compared to vim):
    * less tech debt by removing support for archaic platforms
    * quicker to pump out features and bug fixes
    * first to support async background processes
    * default settings are far more sane
    * it's a drop-in replacement for vim
  * because it works from the terminal
  * because it works without needing a mouse
  * because it's similar to `vi`, which is installed most places by default
    * remain productive even if editing files when ssh-ed into a linux server
    * minor reductions in features compared to local setup
  * because there's a nice way of persisting and syncing configurations (`~/.config/nvim/*`)
* Workspace Manager: [direnv][direnv]
  * because it requires explicit authorization (signature) after each change (unlike `dotenv`)
  * because it only exports variables, not shell functions
  * because it has a nice, extensible [standard library][direnv-stdlib] for settting up project-specific configurations
  * because it is ephemeral and reverts changes when `cd`-ing out of the directory again
  * because it can _optionally_ inherit from the parent/ancestor directory's `.envrc`
  * because it makes it very easy to facilitate using environment variables to store sensitive info
  * because it makes it very easy to sandbox python development using `virtualenv`
* Python Version Changer: [pyenv][pyenv]
  * because it makes it easy to install a new version of python
  * because it's easy to install and update the framework
  * because it's lightweight
  * because it observes directory-specific configurations (`.python-version`)
  * because it's easy to pop out and use system versions of python instead (`PYENV_VERSION=system <command>`)
* Ruby Version Changer: [chruby][chruby]
  * because system versions of ruby are often EOL-ed
  * because it's simple (~100 LoC, making it much easier to troubleshoot)
  * because it offloads installation to another tool: `ruby-install`
  * because it leans into the sanboxing built into tools like `rubygems` and `bundler` (unlike `rvm`)
  * because it points directly to executables instead of using shims (unlike `rbenv`)
  * because it _optionally_ obeserves directory-specific configurations (`.ruby-version`)
  * because releases are signed with GPG keys

[homebrew]: http://homebrew.sh
[rubygems]: https://rubygems.org
[npm]: https://npmjs.org
[go-lang]: https://golang.org
[pip]: https://pip.pypa.io/
[vim-plug]: https://github.com/junegunn/vim-plug
[alacritty]: https://github.com/jwilm/alacritty
[keepassxc]: https://keepassxc.org/
[rclone]: https://rclone.org/
[keepassxc-cloud-syncing]: https://keepassxc.org/docs/#faq-cloudsync
[keepass-android]: https://github.com/PhilippC/keepass2android
[keepass-ios]: https://itunes.apple.com/us/app/keepass-touch/id966759076
[neovim]: https://neovim.io
[direnv]: https://direnv.net
[direnv-stdlib]: https://direnv.net/#man/direnv-stdlib.1
[pyenv]: https://github.com/pyenv/pyenv
[chruby]: https://github.com/postmodern/chruby

[NeoVim][neovim] configuration:

* Set `<leader>` to a single space.
* Idea scaffolding and notes, similar to org-mode, with [vimwiki][vimwiki]
* Honor project maintainer's preferences (e.g., tabs vs spaces, line endings) from [`.editorconfig`][editorconfig] using [editorconfig-vim][vim-editorconfig]
* [Syntax highlighting][vim-polyglot] and [linting][ale] for many languages
* Default theme: [Solarized (dark)][vim-solarized]

[vim-polyglot]: https://github.com/sheerun/vim-polyglot
[vim-editorconfig]: https://github.com/editorconfig/editorconfig-vim
[vim-solarized]: https://github.com/altercation/vim-colors-solarized
[ale]: https://github.com/w0rp/ale
[editorconfig]: http://editorconfig.org
[vimwiki]: https://github.com/vimwiki/vimwiki

[`tmux`](http://robots.thoughtbot.com/a-tmux-crash-course) configuration:

* Improved color resolution for modern terminal emulators
* Soften status bar color from harsh green to light gray
* Simplified the status bar to just session name, hostname, and time
* Set leader key to `Ctrl+Space`
* Nested tmux session receives its leader key with `<Leader> Ctrl+Space`
* Switch between sessions with `<Leader> Space`
* Split window with visually appealing vertical (`|`) and horizontal (`-`) splits

[`git`](https://git-scm.com/) configuration:

* Alias: `git camend` for amending commit latest commit without changing message
* Alias: `git ci` to commit, showing the entire changeset being committed below the commit message for review purposes (will not be included in commit message)
* Alias: `git cundo` to go back to just before you executed `git commit`
* Alias: `git current-branch` for name of current branch
* Alias: `git l` for a reasonable commit log overview
* Alias: `git ls` for a detailed commit log overview, including stats
* Alias: `git ld` for a detailed commit log overview, including stats and diffs
* Alias: [`git lola`][git-lola-expl] (see link for details)
* Alias: `git up` for fetching and rebasing `origin/master` into the feature branch. Use `git up -i` for interactive rebases.
* Alias: `git versions` for aliasing `git-releases` (below)
* Command: `git ca` to amend the latest commit, updating the commit date to current
* Command: `git churn` to show churn for the files changed in the branch
* Command: `git ctags` to rerun git hook for regenerating project-wide ctags
* Command: `git fixup` for a [fixup][git-fixup-expl]-style git workflow
* Command: `git latest-version` for the latest version tag, matching a `v0.0.0`-style
* Command: `git log-versions` for listing what we _guess_ should be commits that are (or should be) tagged with the `v0.0.0`-style version tags. Displays commit log and diff of the file containing the version identifier
* Command: `git releases` for a list of tags matching a `v0.0.0`-style of version tag
* Command: `git trust` to create the directory `.git/safe` (which allows `./bin` to be added to PATH) (Deprecated. Use `direnv` instead)
* Command: `git unpushed` to list all changes between the latest local commit and what's on the matching remote branch
* Command: `git unpushed-stat` to list all files changed between the latest local commit and what's on the matching remote branch
* Config: Automatically squash fixup and revert commits
* Config: Better coloring
* Config: Default message from `~/.gitmessage`
* Config: Diff pager is run through [`diff-so-fancy`][diff-so-fancy]
* Config: Rebasing automatically squashes fixup and revert commits
* Config: Rebasing automatically stashes uncommitted changes
* Config: Signing commits with default GPG key, unless explicitly skipped

[git-fixup-expl]: https://blog.filippo.io/git-fixup-amending-an-older-commit/
[git-lola-expl]: http://blog.kfish.org/2010/04/git-lola.html
[diff-so-fancy]: https://github.com/so-fancy/diff-so-fancy

Shell aliases and functions:

* `b` for `bundle`.
* `be` for `bundle exec` (see [`yonce` CLI](https://github.com/ddfreyne/yonce) for context)
* `g` with no arguments is `git status` and with arguments acts like `git`.
* `vim` for `nvim` (because I'm lazy)

Miscellaneous shell scripts:

* `bundle search` to search within every gem and dependency in a Gemfile
* `catch-gem-failures` to fix issues on bundle install with `Try: gem pristine some_gem --version 0.3.2` errors
* `certbot-auto` to handle Let's Encrypt certificates
* `dbuild` for building docker containers
* `dconsole` for stepping into a docker container
* `docker-cleanup` for removing orphaned docker containers and images
* `deploy-wiki` for deploying a compiled vim-wiki site at `~/Documents/*-wiki` to Netlify
* `http-serve` for starting an HTTP server in the current directory
* `tat` to create/attach to tmux session named the same as the current directory.
* `tlt` to list running tmux sessions
* `{push,pull,sync}-keepass-databases` commands for cloud storage support of multiple KeePassXC vaults

Thanks
------

Thank you, [thoughtbot (and contributors)](https://github.com/thoughtbot/dotfiles/contributors) for initial scaffolding of dotfiles repository.

License
-------

dotfiles is copyright © 2009-2020 thoughtbot and David Alexander. It is free software, and may be redistributed under the terms specified in the [`LICENSE`] file.

[`LICENSE`]: /LICENSE
