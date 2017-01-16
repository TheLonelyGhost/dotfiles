#!/usr/bin/env python2

import os
import platform


def log(msg):
    print("dotfiles: %s" % msg)


def whereis(executable):
    location = None
    for path in os.environ.get('PATH', '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin').split(':'):
        bin = os.path.join(path, executable)
        if os.path.exists(bin):
            location = bin
            break
    if location is None:
        raise Exception("Could not find where `%s' is installed" % executable)
    return location


class Platform:
    packages = []
    name = None

    def name(self):
        if self.name is None:
            raise Exception("Not implemented")
        return self.name

    def change_shell(self, shell='zsh'):
        shell_bin = whereis(shell)
        os.system('chsh -s "%s"' % shell_bin)

    def install_dependencies(self):
        self.install_git()
        self.install_zsh()
        self.install_rcm()
        self.exec_package_install()

    def exec_package_install(self):
        raise Exception("Not implemented")

    def install_git(self):
        raise Exception("Not implemented")

    def install_zsh(self):
        raise Exception("Not implemented")

    def install_rcm(self):
        raise Exception("Not implemented")


class MacOS(Platform):
    brew_taps = []
    name = "Mac OS"

    def install_dependencies(self):
        self.install_homebrew()
        super(MacOS, self)

    def exec_package_install(self):
        for tap in self.brew_taps:
            # execute `brew tap`
            os.system('brew tap %s' % tap)
        if len(self.packages) > 0:
            # update brew cache
            os.system('brew update')
            os.system('brew upgrade')
            # execute `brew install` on culmination of all packages
            os.system('brew install %s' % ' '.join(self.packages))

    def install_git(self):
        self.packages.append('git')

    def install_zsh(self):
        self.packages.append('zsh')

    def install_rcm(self):
        self.brew_taps.append('thoughtbot/formulae')
        self.packages.append('rcm')

    def install_homebrew(self):
        raise Exception("Not implemented")


class Ubuntu(Platform):
    ppa_repositories = []
    name = "Ubuntu"

    def exec_package_install(self):
        for repo in self.ppa_repositories:
            os.system('sudo add-apt-repository -y ppa:%s' % repo)
        if len(self.packages) > 0:
            os.system('sudo apt-get update')
            os.system('sudo apt-get install -y %s' % ' '.join(self.packages))

    def install_git(self):
        self.packages.append('git-core')

    def install_zsh(self):
        self.packages.append('zsh')

    def install_rcm(self):
        self.ppa_repositories.append('martin-frost/thoughtbot-rcm')
        self.packages.append('rcm')


class Fedora(Platform):
    """
    [WIP] Platform-specific setup commands for Fedora platforms
    """
    name = "Fedora"


def get_platform():
    """
    Detects the current platform and returns a new Platform child-object
    """
    if platform.system() == "Darwin":
        return MacOS()

    elif platform.dist()[0] == "Ubuntu":
        if platform.dist()[2] != "xenial":
            raise Exception("Unsupported Ubuntu version ('%s', '%s', '%s')" %
                            platform.dist())
        return Ubuntu()

    elif platform.dist()[0] == "Fedora":
        return Fedora()

    else:
        raise Exception("Unsupported platform detected: '%s'" % platform)


def install_dependencies():
    log("Installing dependencies...")
    get_platform().install_dependencies()


def change_shell(shell='zsh'):
    if os.environ.get('SHELL', '').endswith(shell):
        return
    log("Changing the registered shell to %s" % shell)
    get_platform().change_shell(shell)


def clone_dotfiles_repo(repository_url='https://gitlab.com/thelonelyghost/dotfiles.git'):
    if os.path.exists(os.path.join(os.environ.get('HOME', '~'), '.dotfiles')):
        return
    log("Cloning dotfiles git repository to `~/.dotfiles'...")
    git = whereis('git')
    os.system('%s clone %s "%s/.dotfiles"' % (git, repository_url, os.environ.get('HOME', '~')))


def rcup():
    if not os.path.exists(os.path.join(os.environ.get('HOME', '~'), '.dotfiles', 'rcrc')):
        return
    log("Running initial `rcup`. This may take a while...")
    env = whereis('env')
    rcup = whereis('rcup')
    os.system('%s RCRC="%s/.dotfiles/rcrc" %s' % (env, os.environ.get('HOME', '~'), rcup))


if __name__ == "__main__":
    install_dependencies()
    change_shell('zsh')
    clone_dotfiles_repo('git@gitlab.com:thelonelyghost/dotfiles.git')
    rcup()
