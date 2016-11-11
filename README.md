thelonelyghost's dotfiles
=========================

TODO: insert photo preview of dotfiles

Requirements
------------

Set zsh as your login shell:

    chsh -s $(which zsh)

Install
-------

Clone onto your laptop:

    git clone git://gitlab.com/thelonelyghost/dotfiles.git ~/.dotfiles

(Or, [fork and keep your fork
updated](http://robots.thoughtbot.com/keeping-a-github-fork-updated)).

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
runs of `rcup`). [See
example](https://gitlab.com/thelonelyghost/dotfiles/blob/master/rcrc).

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
* `~/.git_template.local/*`
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

zsh Configurations
------------------

Additional zsh configuration can go under the `~/.zsh/configs` directory. This
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

Similarly to the zsh configuration directory as described above, vim
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

- Manager: `apt-get` (Ubuntu) - `hooks/packages/apt`
- Manager: [`homebrew`](http://homebrew.sh) (MacOS) - `hooks/packages/brew`
- Manager: [`gem`](https://rubygems.org) (Ruby) - `hooks/packages/rubygems`
- Manager: [`npm`](https://npmjs.org) (Node) - `hooks/packages/npm`
- Manager: [`go get`](https://golang.org) (Go) - `hooks/packages/go`
- Manager: [`pip`](https://pip.pypa.io/) (Python) - `hooks/packages/pip`
- Version Switcher: [`chruby`](https://github.com/postmodern/chruby) (Ruby)
- Feature: Cache updating package manager because network latency is expensive
- Feature: NPM installs to directory in user space, so no sudo is required for global installs
- Feature: Rubygems install to directory in user space, so no sudo is required for install

[vim](http://www.vim.org/) configuration:

* [Integration with tmux][vim-tmux-navigator] for more convenient navigation between splits, regardless of if vim or tmux started it
* [Ctrl-P](https://github.com/kien/ctrlp.vim) for fuzzy file/buffer/tag finding.
* [Syntax highlighting](https://github.com/sheerun/vim-polyglot) and [linting](https://github.com/scrooloose/syntastic) for many languages
* Highlight matching brackets (`[]`, `()`, and `{}`)
* Set `<leader>` to a single space.
* Switch between the last two files with space-space in normal mode.
* Use [vim-mkdir](https://github.com/pbrisbin/vim-mkdir) for automatically creating non-existing directories before writing the buffer.
* Use [vim-plug](https://github.com/junegunn/vim-plug) to manage plugins.
* Default theme of [`vividchalk`](https://github.com/tpope/vim-vividchalk)

[vim-tmux-navigator]: https://github.com/chrostoomey/vim-tmux-navigator

[tmux](http://robots.thoughtbot.com/a-tmux-crash-course)
configuration:

* Improve color resolution.
* Remove some administrative debris (session name, hostname, time) in status bar.
* Set prefix to `Ctrl+Space`
* Soften status bar color from harsh green to light gray.
* Work with [vim support][vim-tmux-navigator] for transparently navigating splits
* Switch between sessions with `Ctrl+Space Space`
* Switch between last used buffers with `Ctrl+Space Ctrl+Space`
* Split window with visually appealing vertical (`|`) and horizontal (`-`) splits

[git](http://git-scm.com/) configuration:

* Config: Better coloring
* Alias: `camend` for amending commit latest commit without changing message
* Alias: `up` for fetching and rebasing `origin/master` into the feature branch. Use `git up -i` for interactive rebases.
* Command: `fixup` for a [fixup][git-fixup-expl] git workflow
* Command: `churn` to show churn for the files changed in the branch
* Command: `ca` to amend the latest commit, updating the commit date to current
* Command: `ctags` to rerun git hook for regenerating project-wide ctags
* Alias: `cundo` to go back to just before you executed `git commit`
* Alias: `current-branch`
* Alias: `l` for a reasonable commit log overview
* Alias: `ls` for a detailed commit log overview, including stats
* Alias: `ld` for a detailed commit log overview, including stats and diffs
* Alias: [`lola`][git-lola-expl]
* Config: Automatically squash fixup and revert commits
* Config: Default message from `~/.gitmessage`
* Config: Diff pager is run through [`diff-so-fancy`][diff-so-fancy]
* Config: Rebasing automatically squashes fixup and revert commits
* Config: Rebasing automatically stashes uncommitted changes
* Config: Commit- and push-signing using default GPG key
* Hook: `post-{checkout,commit,merge}` hooks re-index your ctags
* Hook: `pre-commit` and `prepare-commit-msg` stubs also delegate to your associated `*.local` config.

[git-fixup-expl]: https://blog.filippo.io/git-fixup-amending-an-older-commit/
[git-lola-expl]: http://blog.kfish.org/2010/04/git-lola.html
[diff-so-fancy]: https://github.com/so-fancy/diff-so-fancy

[Ruby](https://www.ruby-lang.org/en/) configuration:

* Add trusted binstubs to the `PATH`.
* Load rbenv into the shell, adding shims onto our `PATH`.

Shell aliases and scripts:

* `b` for `bundle`.
* `be` for `bundle exec` (see [`yonce` CLI](https://github.com/ddfreyne/yonce) for context)
* `g` with no arguments is `git status` and with arguments acts like `git`.
* `migrate` to test pending rails migrations, test reverting them, and rerun migrations again
* `replace foo bar **/*.rb` to find and replace within a given list of files.
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
