# Customizing configurations

RCM is built on the concept of overrides. If 2 or more dotfiles repositories have the exact same file in them, calling `rcup` will only symlink the file from the repository with [the highest priority](#priority).

For the most part, the configurations for each program tries to follow the "one file per concept" approach. If you disagree with choices made by any individual concept, it can likely be overridden with surgical precision.

## Priority

Dotfiles repositories, if using the RCM framework, are given a priority according to the RCM configuration file (given by `RCRC` environment variable with default set to `~/.rcrc`). Inside of that configuration file, which is just a shell script, there is a variable defined called `DOTFILES_DIRS`. That is where this priority is established. Whatever repository comes **LAST** in the list holds highest priority.

What does this mean? Consider the configuration below.

```
# File: ~/.rcrc

DOTFILES_DIRS="~/.dotfiles ~/.customizations-dotfiles"
```

In this configuration, there are 2 repositories, one which is the default repository (this one) and one which is more lean, perhaps only filled with additional customizations. The second repository, filled with customizations, holds higher priority.

## Overrides

Okay, but how does priority actually affect anything?

Let's say I have a file in the default repository at `zsh/configs/prompt.zsh`, which configures my ZSH shell prompt. If I put a blank file in my customizations repository at that same path, RCM will choose to symlink the file from my customizations repository over the one in the default repository.

This means by adding a blank file to my customizations repository, I can negate customizations. I can also fill that file with a different configuration than the one in the default repository.

This is the power that RCM provides, and a major reason why it was chosen for managing my workstation configuration.

This is easy to include all files in a directory when configuring a shell, but what about other programs that it isn't so easy?

### Configuring from multiple files

Some programs (like `kubectl`) natively support the overlay of configurations from several sources.

In the case of `kubectl` there's an environment variable it reads called `KUBECONFIG`, which is treated like a `PATH` of all of the configuration files it reads and creates an in-memory composite configuration.

When available, this option is most workable since it allows us to build the `KUBECONFIG` variable using a shell config file in `~/.zsh/config/` based on the existence of files in a particular path.

### Compiling config files

Some configurations, such as with OpenSSH's `~/.ssh/config`, putting several files in a directory by the same name as the configuration file + `.d` (`~/.ssh/config` -> `~/.ssh/config.d/`) doesn't mean they will be evaluated. This is where compilers come in handy.

In the case of `~/.ssh/config` specifically, its syntax is flexible enough that concatenating all files in the `~/.ssh/config.d/` directory and writing it to `~/.ssh/config` works out well. For this case, there is a shell program that handles this nicely called [Instant.d](https://github.com/thelonelyghost/insta.d).

This specific compiler wouldn't work in the case of `kubectl`, whose configuration is YAML and cannot be blatantly concatenated from several sources to a single file. That doesn't mean a compiler couldn't be written to handle it.

**NOTE:** Changes to the symlinked file would normally show up as modified in the dotfiles repo, but since the compiler's output isn't symlinked to the repository, it does not give that notice.

### Local configs

When all else fails, overriding the main configuration file is also okay. We aren't always able to keep to the "one file per concept" approach.
