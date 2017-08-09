thelonelyghost's dotfiles
=========================

TODO: insert photo preview of dotfiles

Quick Install
-------------

    curl -SsL https://gitlab.com/thelonelyghost/dotfiles/raw/master/hooks/setup.sh | bash -

OR

    curl -SsL http://dotfiles.thelonelyghost.com/setup.sh | bash -

Manual Install
--------------

Set zsh as your login shell:

    chsh -s $(which zsh)

Clone onto your laptop:

    git clone git://gitlab.com/thelonelyghost/dotfiles.git ~/.dotfiles

(Or, [fork and keep your fork updated](http://robots.thoughtbot.com/keeping-a-github-fork-updated)).

Install [rcm](https://github.com/thoughtbot/rcm):

    # Mac OS (Homebrew)
    brew tap thoughtbot/formulae
    brew install rcm

    # Ubuntu
    sudo add-apt-repository -y ppa:martin-frost/thoughtbot-rcm
    sudo apt-get install -y rcm

Install the dotfiles:

    env RCRC=$HOME/.dotfiles/rcrc rcup

After the initial installation, you can run `rcup` without the one-time variable
`RCRC` being set (`rcup` will symlink the repo's `rcrc` to `~/.rcrc` for future
runs of `rcup`). [See example](https://gitlab.com/thelonelyghost/dotfiles/blob/master/rcrc).

This command will create symlinks for config files in your home directory.
Setting the `RCRC` environment variable tells `rcup` to use standard
configuration options:

* Exclude the `README.md` and `LICENSE` files, which are part of
  the `dotfiles` repository but do not need to be symlinked in.
* Give precedence to personal overrides which by default are placed in
  `~/.dotfiles-local`
* Copy the templates for new git repositories instead of referencing one
  canonical location for all repositories

You can safely run `rcup` multiple times to update:

    rcup

You should run `rcup` after pulling a new version of the repository to symlink
any new files in the repository.

Make your own customizations
----------------------------

Put your customizations in dotfiles appended with `.local`:

* `~/.aliases.local`
* `~/.git_template/*.local`
* `~/.gitconfig.local`
* `~/.psqlrc.local` (we supply a blank `.psqlrc.local` to prevent `psql` from
  throwing an error, but you should overwrite the file with your own copy)
* `~/.tmux.conf.local`
* `~/.vimrc.local`
* `~/.vimrc.bundles.local`
* `~/.zshrc.local`
* `~/.zsh/configs/*`

For example, your `~/.aliases.local` might look like this:

    # Productivity
    alias todo='$EDITOR ~/.todo'

Your `~/.gitconfig.local` might look like this:

    [alias]
      l = log --pretty=colored
    [pretty]
      colored = format:%Cred%h%Creset %s %Cgreen(%cr) %C(bold blue)%an%Creset
    [user]
      name = Dan Croak
      email = myname@example.com

Your `~/.vimrc.local` might look like this:

    " Color scheme
    colorscheme github
    highlight NonText guibg=#060606
    highlight Folded  guibg=#0A0A0A guifg=#9090D0

To extend your `git` hooks, create executable scripts in
`~/.git_template.local/hooks/*` files.

Your `~/.zshrc.local` might look like this:

    # load pyenv if available
    if which pyenv &>/dev/null ; then
      eval "$(pyenv init -)"
    fi

Your `~/.vimrc.bundles.local` might look like this:

    Plug 'Lokaltog/vim-powerline'
    Plug 'stephenmckinney/vim-solarized-powerline'

`zsh` Configurations
--------------------

Additional `zsh` configuration can go under the `~/.zsh/configs` directory. This
has two special subdirectories: `pre` for files that must be loaded first, and
`post` for files that must be loaded last.

For example, `~/.zsh/configs/pre/virtualenv` makes use of various shell
features which may be affected by your settings, so load it first:

    # Load the virtualenv wrapper
    . /usr/local/bin/virtualenvwrapper.sh

Setting a key binding can happen in `~/.zsh/configs/keys`:

    # Grep anywhere with ^G
    bindkey -s '^G' ' | grep '

Some changes, like `chpwd`, must happen in `~/.zsh/configs/post/chpwd.zsh`:

    # Show the entries in a directory whenever you cd in
    function chpwd {
      ls
    }

This directory is handy for combining dotfiles from multiple teams; one team
can add the `virtualenv` file, another `keys`, and a third `chpwd`.

The `~/.zshrc.local` is loaded after `~/.zsh/configs`.

vim Configurations
------------------

Similarly to the `zsh` configuration directory as described above, vim
automatically loads all files in the `~/.vim/plugin` directory. This does not
have the same `pre` or `post` subdirectory support that our `zshrc` has.

This is an example `~/.vim/plugin/c.vim`. It is loaded every time vim starts,
regardless of the file name:

    # Indent C programs according to BSD style(9)
    set cinoptions=:0,t0,+4,(4
    autocmd BufNewFile,BufRead *.[ch] setlocal sw=0 ts=8 noet

What's in it?
-------------

System packages:

* Manager: `apt-get` (Ubuntu) - `hooks/packages/apt`
* Manager: [`homebrew`][homebrew] (MacOS) - `hooks/packages/brew`
* Manager: [`gem`][rubygems] (Ruby) - `hooks/packages/rubygems`
* Manager: [`npm`][npm] (Node) - `hooks/packages/npm`
* Manager: [`go get`][go-lang] (Go) - `hooks/packages/go`
* Manager: [`pip`][pip] (Python) - `hooks/packages/pip`
* Manager: [`vim-plug`][vim-plug] (vim) - `vimrc.bundles` (OPTIONAL: also `~/.vimrc.bundles.local`)
* Manager: [`vim-plug`][vim-plug] (NeoVim) - `config/nvim/bundle.vim` (OPTIONAL: also `~/.config/nvim/bundles.vim.local`)
* Feature: Cache updating package manager because network latency is expensive
* Feature: `npm` installs to directory in user space, so no `sudo` is required for global installs
* Feature: `gem` installs to directory in user space, so no `sudo` is required for install

[homebrew]: http://homebrew.sh
[rubygems]: https://rubygems.org
[npm]: https://npmjs.org
[go-lang]: https://golang.org
[pip]: https://pip.pypa.io/
[vim-plug]: https://github.com/junegunn/vim-plug

[`vim`](http://www.vim.org/) configuration:

* Highlight matching brackets (`[]`, `()`, and `{}`)
* Set `<leader>` to a single space.
* Switch between the last two files with space-space in normal mode.
* Idea scaffolding, similar to org-mode, with [vimwiki][vimwiki]
* Honor project maintainer's preferences (e.g., tabs vs spaces, line endings) from [`.editorconfig`][editorconfig] using [editorconfig-vim][vim-editorconfig]
* [Syntax highlighting][vim-polyglot] and [linting][syntastic] for many languages
* [Integration with tmux][vim-tmux-navigator] for convenient navigation between splits, regardless of if `vim` or `tmux` started it
* Use [vim-mkdir][vim-mkdir] to automatically create parent directories as needed before writing the buffer.
* Default theme: [`vividchalk`][vim-vividchalk]
* ... [a bunch of other plugins](/vimrc.bundles)

[vim-tmux-navigator]: https://github.com/chrostoomey/vim-tmux-navigator
[vim-polyglot]: https://github.com/sheerun/vim-polyglot
[vim-editorconfig]: https://github.com/editorconfig/editorconfig-vim
[vim-mkdir]: https://github.com/pbrisbin/vim-mkdir
[vim-vividchalk]: https://github.com/tpope/vim-vividchalk
[syntastic]: https://github.com/scrooloose/syntastic
[editorconfig]: http://editorconfig.org
[vimwiki]: https://github.com/vimwiki/vimwiki

[`tmux`](http://robots.thoughtbot.com/a-tmux-crash-course)
configuration:

* Improve color resolution.
* Remove some administrative debris (session name, hostname, time) in status bar.
* Set prefix to `Ctrl+Space`
* Soften status bar color from harsh green to light gray.
* Switch between sessions with `<Leader> Space`
* Switch between last used buffers with `<Leader> Ctrl+Space`
* Split window with visually appealing vertical (`|`) and horizontal (`-`) splits

[`git`](https://git-scm.com/) configuration:

* Alias: `camend` for amending commit latest commit without changing message
* Alias: `ci` to commit, showing the entire changeset being committed below the commit message for review purposes (will not be included in commit message)
* Alias: `cundo` to go back to just before you executed `git commit`
* Alias: `current-branch` for name of current branch
* Alias: `l` for a reasonable commit log overview
* Alias: `ls` for a detailed commit log overview, including stats
* Alias: `ld` for a detailed commit log overview, including stats and diffs
* Alias: [`lola`][git-lola-expl] (see link for details)
* Alias: `up` for fetching and rebasing `origin/master` into the feature branch. Use `git up -i` for interactive rebases.
* Alias: `versions` for aliasing `git-releases` (below)
* Command: `ca` to amend the latest commit, updating the commit date to current
* Command: `churn` to show churn for the files changed in the branch
* Command: `ctags` to rerun git hook for regenerating project-wide ctags
* Command: `fixup` for a [fixup][git-fixup-expl]-style git workflow
* Command: `latest-version` for the latest version tag, matching a `v0.0.0`-style
* Command: `releases` for a list of tags matching a `v0.0.0`-style of version tag
* Command: `trust` to create the directory `.git/safe` (which allows `./bin` to be added to PATH)
* Command: `upushed` to list all changes between the latest local commit and what's on the matching remote branch
* Command: `upushed-stat` to list all files changed between the latest local commit and what's on the matching remote branch
* Config: Automatically squash fixup and revert commits
* Config: Better coloring
* Config: Default message from `~/.gitmessage`
* Config: Diff pager is run through [`diff-so-fancy`][diff-so-fancy]
* Config: Rebasing automatically squashes fixup and revert commits
* Config: Rebasing automatically stashes uncommitted changes
* Config: Signing commits and pushes using default GPG key

[git-fixup-expl]: https://blog.filippo.io/git-fixup-amending-an-older-commit/
[git-lola-expl]: http://blog.kfish.org/2010/04/git-lola.html
[diff-so-fancy]: https://github.com/so-fancy/diff-so-fancy

[Ruby](https://www.ruby-lang.org/) configuration:

* Use [`chruby`](https://github.com/postmodern/chruby) automatically
* Auto-switch between ruby versions and associated installed gems according to `.ruby-version` standard

Shell aliases and functions:

* `b` for `bundle`.
* `be` for `bundle exec` (see [`yonce` CLI](https://github.com/ddfreyne/yonce) for context)
* `g` with no arguments is `git status` and with arguments acts like `git`.

Miscellaneous shell scripts:

* `bundle search` to search within every gem and dependency in a Gemfile
* `catch-gem-failures` to fix issues on bundle install with `Try: gem pristine some_gem --version 0.3.2` errors
* `certbot-auto` to handle Let's Encrypt certificates
* `dbuild` for building docker containers
* `dconsole` for stepping into a docker container
* `docker-cleanup` for removing orphaned docker containers and images
* `deploy-wiki` for deploying a compiled vim-wiki site at `~/Documents/*-wiki` to Netlify
* `http-serve` for starting an HTTP server in the current directory
* `tat` to attach to tmux session named the same as the current directory.
* `tlt` to list running tmux sessions

Thanks
------

Thank you, [thoughtbot (and contributors)](https://github.com/thoughtbot/dotfiles/contributors)
for initial scaffolding of dotfiles repository.

License
-------

dotfiles is copyright © 2009-2016 thoughtbot and David Alexander. It is free
software, and may be redistributed under the terms specified in the [`LICENSE`]
file.

[`LICENSE`]: /LICENSE
