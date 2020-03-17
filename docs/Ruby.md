# Chruby / ruby-install

TODO

* Manager: [`gem`][rubygems] (Ruby) - `hooks/packages/rubygems`

* Ruby Version Changer: [chruby][chruby]
  * because system versions of ruby are often EOL-ed
  * because it's simple (~100 LoC, making it much easier to troubleshoot)
  * because it offloads installation to another tool: [`ruby-install`][ruby-install]
  * because it leans into the sandboxing features already built into tools like `rubygems` and `bundler` (unlike `rvm`)
  * because it points directly to executables instead of using shims (unlike `rbenv`)
  * because it _optionally_ obeserves directory-specific configurations (`.ruby-version`)
  * because releases are signed with GPG keys
* Feature: `gem` installs to directory in user space, so no `sudo` is required for install
* `bundle search` to search within every gem and dependency in a Gemfile
* `catch-gem-failures` to fix issues on bundle install with `Try: gem pristine some_gem --version 0.3.2` errors

[rubygems]: https://rubygems.org
[chruby]: https://github.com/postmodern/chruby
[ruby-install]: https://github.com/postmodern/ruby-install
