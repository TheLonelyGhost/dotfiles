# Git

TODO

[`git`](https://git-scm.com/) configuration:

* Alias: `g` instead of `git` or, if no arguments given, `git status -sb`
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
