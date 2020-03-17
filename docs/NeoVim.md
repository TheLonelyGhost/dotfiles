# NeoVim

Similarly to the `zsh` configuration directory as described above, [NeoVim][neovim] automatically loads all files in the `~/.config/nvim/plugin` directory. This does not have the same `pre` or `post` subdirectory support that our `zshrc` has.

This is an example `~/.config/nvim/plugin/c.vim`. It is loaded every time vim starts, regardless of the file name:

```vim
# Indent C programs according to BSD style(9)
set cinoptions=:0,t0,+4,(4
autocmd BufNewFile,BufRead *.[ch] setlocal sw=0 ts=8 noet
```

For any customizations you would put in your `vimrc` (or `init.vim` for NeoVim), instead sync them to the `~/.config/nvim/plugin/` directory as one file per grouping of settings.

## Why NeoVim?

### It's a text editor

Unlike traditional IDEs (e.g., Eclipse, IntelliJ, Visual Studio), NeoVim is nestled into your terminal like `cd`, `mv`, and `ls`. It promotes a shell-first mindset with tighter integration with how your system is configured, which is closer to how it would execute on a production server. Additionally, any shell command can be integrated into NeoVim with little effort. This makes anything your "IDE" (NeoVim) can do easy to also do without the IDE.

IDEs provide a nice environment to get you started, but then there's a disconnect when you try to build, test, or run your program outside of your IDE. Unless you know exactly what it does--and most newbies don't--your program doesn't work as expected unless you run it in your IDE. Why? Because the IDE does some magical setup for you without letting you know what it does. Maybe you can research how it configures things, but who knows if that fits with how your operating system is setup?

Unless you're a _severe_ outlier, IDEs include some features that you will never use. If you're like me, these features are difficult, if not impossible, to disable. Why spend the CPU cycles to have a faulty autocomplete when it's more distracting than helpful? Want to use flake8 to lint your python code but PyCharm only supports using pylint? Too bad.

NeoVim allows you to include exactly what you want on top of its base feature of editing text. The rest it defers to however your shell works. Want to run an arbitrary command? Easy. Reformat the file you're working on, while it's still open? No problem.

### It's vim, but more actively developed

Prior to Vim 8 being released, NeoVim's main claim to fame was that it allowed backgrounding of tasks. No longer would your editor freeze up and disallow you to scroll through the file being edited because you had a syntax checker plugin that was working particularly hard to check the entire file/project.

Nowadays, NeoVim stands for removing technical debt built into Vim, which still exists to provide support for rather archiac platforms that very few people use. Once that's removed, the large number of edge cases for which to test continues to shrink, thereby allowing more rapid development.

Not only for platform support, Vim was also constrained by its expectation of backwards compatibility. Most vim users modify a few key settings (such as `nocompatible`) every time they install Vim. NeoVim maintainers saw that and decided to make the popular end-configuration the new default.

All in all, NeoVim is similar enough to vim that most users won't know the difference outside of the increased speed and stability. It's a nearly complete drop-in replacement for Vim.

### It works from the terminal

As mentioned before, using NeoVim embeds the environment in which you write your programs with the one you use to execute them. It allows effortless access to the full powers of the command line and is itself a command line tool. This means you can even setup a mobile workstation by having some server running in the cloud with SSH access open to it. Login, and your toolset is all setup from any workstation you're using to login.

Additionally, NeoVim is based on Vim, which is based in vi. I have yet to login to a linux server that hasn't had at least vi installed by default. Your personal customizations may not be there, but the same basic concepts still hold: It is embedded with your shell's execution environment and it is able to take advantage of any command available on the system. Within the permissions assigned to your user, that is.

### No need for a mouse

Most zealots of vi/Vim/NeoVim and even Emacs agree that there is power to having your fingers on the keyboard instead of periodically picking up one hand to move it to the mouse, only to move it back to the keyboard a second later. I've even had coworkers specially seek out keyboards that had a [Pointing Stick](https://en.wikipedia.org/wiki/Pointing_stick), like on certain Lenovo Thinkpad laptops, just so they didn't have to move so far from the keyboard to use the mouse. What if you could reduce the amount of movement?

NeoVim (and the rest of the vi-family) supports a 100% keyboard driven approach to use. Those same zealots have written countless documents praising the grammar-like approach to the keys chosen to do each task, even allowing composition involving keys indicating a motion and keys indicating certain objects (e.g., "move forward 3 paragraphs" has the motion "move forward" with the object "paragraph" and the number of times it's repeated "3", which equates to `3}`).

Even the [hyper-extensive help docs][vim-help-motions] are, well, helpful. They're even available from within the program with `:help [topic]`!

### Nice layout for RCM

One of the nicer features about NeoVim is it supports multiple configuration files that can be loaded based on path. We can still adhere to the "one file per concept" approach with it and use RCM's built-in symlinking features from multiple dotfiles sources. See [Customization](Customization.md) for more.

NeoVim, specifically, supports loading files from `~/.config/nvim/plugin/*`. The `~/.config/nvim/` directory is the base directory for the user configurations and there are other spots in that layout which can be used more appropriately. See [vim runtime directory layout][vimruntime-layout] for more.

## What's in it?

My [NeoVim][neovim] configuration has the following customizations from default:

* Manager: [`vim-plug`][vim-plug] (NeoVim) - `config/nvim/bundle.vim` (OPTIONAL: also `~/.config/nvim/bundles.vim.local`)
* `nvim` is aliased to `vim` (because I'm lazy)
* `vimdiff` is aliased to `nvim -d` (for backward compatibility)
* Set `<leader>` to a single space.
* Avoid littering the filesystem with vim-related artifacts
* Navigate to other splits with `CTRL-<direction>` instead of `CTRL-w <direction>`
* Honor project maintainer's preferences (e.g., tabs vs spaces, line endings) from [`.editorconfig`][editorconfig] using [editorconfig-vim][vim-editorconfig]
* [Syntax highlighting][vim-polyglot] and [linting][ale] for many languages
* Language server [integration][coc.nvim] for many languages
* [Visual cues][vim-gitgutter] for git status
* View some types of binary files (`*.bin`, `*.binarycookies`) less horribly using the `xxd` hex editor
* Handle [folding in YAML][yaml-folds] a little nicer
* Use the [Plug][vim-plug] plugin manager for vim
* Default theme: [Solarized (dark)][vim-solarized]

[neovim]: https://neovim.io
[vim-plug]: https://github.com/junegunn/vim-plug
[vim-polyglot]: https://github.com/sheerun/vim-polyglot
[vim-editorconfig]: https://github.com/editorconfig/editorconfig-vim
[vim-solarized]: https://github.com/altercation/vim-colors-solarized
[ale]: https://github.com/dense-analysis/ale
[editorconfig]: http://editorconfig.org
[vim-help-motions]: https://vimhelp.org/motion.txt.html#object-motions
[vimruntime-layout]: https://vimways.org/2018/from-vimrc-to-vim/
[coc.nvim]: https://github.com/neoclide/coc.nvim
[vim-gitgutter]: https://github.com/airblade/vim-gitgutter
[yaml-folds]: https://github.com/pedrohdz/vim-yaml-folds
