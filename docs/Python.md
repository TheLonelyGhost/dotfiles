# Pyenv

I repeatedly reach for python as a go-to tool for handling quick system tasks where more fine-grained control is required than what a shell script provides. Python is also a very good choice for anything involving in-depth interactions with JSON, XML, HTTP requests, or anything more complex than a simple script to get the job done.

Unfortunately, python can be rather brittle if the version changes underneath you, as can happen if you depend on the version bundled with the operating system. Also, quite possibly, the version bundled has some non-standard quirks (looking at you, MacOS with your site-packages location buried in the `~/Library` directory. Rather than normalize that ever-shifting target, it's easier to install python ourselves and get a specific, recent version. [Pyenv][pyenv] helps manage that.

Manager: [`pipx`][pipx] (Python) - `hooks/packages/pip`

## Why Pyenv?

### It's the least invasive

Unlike tools like Anaconda, Pyenv provides a shim for the currently selected version of python, but I only care about the globally installed version. The rest I can have installed and [reference with direnv](Direnv.md). Similar to why I chose [Chruby](Ruby.md) for managing ruby versions, it's a simple program that does only the minimum of what I need. Nothing more.

### Commands are straight-forward

Want to install a new version of python? Call `pyenv install <version>`. Want to list the available versions to install? `pyenv install --list`. Want to list what versions are already installed? `pyenv versions`. Best yet, in case there's anything confusing about it, the `--help` flag displays docs that can navigate anyone through the commands available.

### Allows directory-specific version switching

Thanks to the `.python-version` file you can lay down, and even commit to a repository, it's super easy to switch the current version of python being used. Even more so, we can [use direnv](Direnv.md) to look at the version stored in that file, or use the `PYENV_VERSION` environment variable, or explicitly set the pyenv-installed version as the one to use in direnv's `.envrc` with `use python <version-matcher>`. Super easy!

### Installation and update reuse simple, familiar mechanisms

I work with [git](Git.md) nearly every time I am on my workstation. If there's a way to keep a tool I use updated using mechanisms with which I'm already intimately familiar, more power to it. It also all but guarantees I can point to a different update server (git repo) if need be with very little, if any change to the program.

Installing is as simple as 3 steps:

1. Run `git clone` to download the pyenv repository to `~/.pyenv`
2. Add the `~/.pyenv/bin` directory to your PATH (thereby adding `pyenv` executable there)
3. Call `eval "$(pyenv shell init)"` from your [`~/.zshrc`](Shell.md) (or equivalent config) to initialize the rest of pyenv

## What's in it?

- The actual latest versions of Python 2.x and 3.x installed and available globally
- Defaulting to use Python 3.x, while still making 2.x available for legacy applications
- [`pipx`][pipx] for globally available Python commands available by `pip install`-ing modules, but without their dependencies polluting the global, or even user-specific, site-packages
- All of the platform-specific workarounds for installing Python abstracted away
- Python headers available for compiling native extensions in a Python package

[pyenv]: https://github.com/pyenv/pyenv
[pipx]: https://pipxproject.github.io/pipx/
