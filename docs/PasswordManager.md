# KeePassXC

KeePass is a password storage software that has stood the test of time. Or at least the format has... Over the years, KeePass has seen various forks and facelifts from the original software, and at its heart it's an encrypted XML database. What's so special about this facelift?

[KeePassXC][keepassxc] is a fork of KeePassX, which forks KeePass in the same way KeePass2 did, but in a more platform-agnostic manner. Did you get all that?

Basically, KeePassXC is the latest in the long line of forks that has seen a resurgence of interest, works cross-platform (windows, mac, linux), and knows where to draw the line when it comes to features (cloud sync). By using KeePassXC, it stores the data in a well-established, battle-tested format that can be decrypted by other clients too, including ones on mobile devices.

## Why KeePassXC?

### Active development

Unlike the other forks, this one is kept up-to-date. This means it includes more recent cipher suites for encryption, a wider range of ciphers to choose from, adds some features that have been lobbied for (and even proposed with implementations), and does so with a much nicer UI.

### Really nice features

Some of these features that stand out to me are...

- Injecting private keys stored in your KeePass database into a running SSH agent (and withdrawing them when the database is locked again)
- Auto-typing keyboard emulation (with [additional safety measures][autotype-security] and [templating][autotype-templating])
- TOTP support for multi-factor auth
- [HIBP offline checker][hibp-checker] for pwn'ed passwords using an [offline database][hibp-data]
- Sub-databases if you'd like to share and sync a subset of your credentials with one or more people
- Browser extensions for filling out form inputs (though I'd recommend using the auto-type feature instead)
- Global auto-fill prompt
- Multiple KeePass databases open at the same time

### CLI availability

KeePassXC has a command line tool that ships with it, though you wouldn't necessarily know it unless you did some digging. It is possible to write a script to extract the password of one specific entity from your KeePass database.

I'll admit it's not very easy to do so and I haven't seen it improve my security practices quite yet, but it's close.

There's even a [feature for checking your passwords][hibp-checker] against the [HIBP database][hibp-data] of leaked credentials, provided you have an offline copy of that database (it's free to download, but VERY large).

### REALLY Cross-platform

I'm able to sync my password databases securely across all of my devices, keeping them in-sync and not worrying about editing something on one device getting accidentally overwritten when writing something else to a copy of the same database on another device.

Hooked up with SyncThing, I've had a lot of luck with this instantaneous synchronization directly from one device to another. This means my phone (with KeePass support for [Android][android-keepass] and [iPhone][ios-keepass]) has access to my entire password store and it's kept just as up-to-date as my desktop or one of my laptops. It also means I have it available offline even if I'm without internet access for a given period of time.

## What's in it?

Not a whole lot can be securely stored as a dotfile, as far as configuration is concerned. I tend to set the following preferences and call it a day:

- Global Auto-Type shortcut is set to `Ctrl+Alt+Shift+Space`
- SSH agent injection is enabled, but is still too buggy to use with my current workstation setup
- The browser extension support is disabled because I don't use it
- Previously used databases are remembered
- Option to "Safely save database files" is enabled
- Automatic save after every change is enabled
- Minimizing the app instead of app exit
- Show a (dark) system tray icon
- Database is locked when my session is locked or lid is closed
- Don't require password repeat when password is visible
- Hide passwords in the entry preview panel
- Use DuckDuckGo service to download website icons

[keepassxc]: https://keepassxc.org
[autotype-security]: https://keepass.info/help/v2/autotype_obfuscation.html
[autotype-templating]: https://github.com/keepassxreboot/keepassxc/wiki/Autotype-Custom-Sequence
[hibp-checker]: https://github.com/keepassxreboot/keepassxc/issues/2707
[hibp-data]: https://haveibeenpwned.com/Passwords
[ios-keepass]: https://keepassium.com/
[android-keepass]: https://www.keepassdx.com/
