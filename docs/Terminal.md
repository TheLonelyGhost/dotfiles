# Alacritty

[Alacritty][alacritty] is a cross-platform (MacOS, Linux) terminal emulator built from the ground-up to be fast. It specifically leaves out certain features because existing software, frankly, does it better and more efficiently. There's no reason to be redundant here.

## Why Alacritty?

### Cross-platform support

With few exceptions (e.g., fonts), Alacritty can be configured entirely with a YAML configuration file. The same cannot be said for other terminal emulators and that simplicity is very much appreciated with using RCM to sync my workstation configuration files.

Given Alacritty's cross-platform support of unicode characters and much more straightforward process to download and compile myself, if the need should ever arise, it jumps in the lead for a single tool regardless of operating system.

### Engine, tires, and steering wheel only

Another aspect that sets Alacritty apart from other terminal emulators is that it includes only the bare minimum. Things like scrolling back to what was previously displayed can be handled by another tool already in my arsenal: tmux. Same with copy-paste, right-clicking, all kinds of interactive menus, and so forth. All we really need to get value from this software is what it provides. Nothing more.

### It's really fast!

Part of the benefit of this no-frills terminal emulator is that those features it left behind were bloat. That bloat slowed down the application. What happens when that bloat is removed? It's speeds it up. A lot. [No, seriously][alacritty-speedy].

## What's in it?

Not a whole lot beyond the defaults. Given the rapid pace of development and pre-1.0 version (when following [SemVer][semver]), features in the configuration file are added and deprecated quite fast. Rather than figure it out fresh each time, it's easier just to ride the wave of defaults.

[alacritty]: https://github.com/alacritty/alacritty
[alacritty-speedy]: https://jwilm.io/blog/announcing-alacritty/
[semver]: https://www.semver.org/
