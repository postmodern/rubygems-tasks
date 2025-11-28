# rubygems-tasks

[![CI](https://github.com/postmodern/rubygems-tasks/actions/workflows/ruby.yml/badge.svg)](https://github.com/postmodern/rubygems-tasks/actions/workflows/ruby.yml)
[![Code Climate](https://codeclimate.com/github/postmodern/rubygems-tasks.svg)](https://codeclimate.com/github/postmodern/rubygems-tasks)

* [Source](https://github.com/postmodern/rubygems-tasks)
* [Forum](https://github.com/postmodern/rubygems-tasks/discussions) |
  [Issues](https://github.com/postmodern/rubygems-tasks/issues)
* [Documentation](https://rubydoc.info/gems/rubygems-tasks)

## Description

rubygems-tasks provides [Rake] tasks for building and releasing Ruby Gems.
rubygems-tasks can be added to any Ruby project that has a `Rakefile` and a
`.gemspec` file.

## Features

* Provides [Rake] tasks to build, install, or release gem packages to
  [rubygems.org].
* Supports pushing gem packages to internal [gem servers].
* Additionally supports creating `.tar.gz` of `.zip` source archives.
* Loads all project metadata from the `.gemspec` file.
* Supports Ruby projects with multiple `.gemspec` files.
* Supports [Git], [Mercurial], [SubVersion], or even no SCM at all.
* Enforces important safety checks:
  * Checks for uncommitted changes before building a gem.
  * Pushes all commits and tags before pushing a gem.
* Provides additional enhanced security features:
  * Supports optionally creating PGP signed [Git] or [Mercurial] tags.
  * Supports optionally generating checksums or PGP signatures of the `.gem`
    package.

## Requirements

* [ruby] >= 2.0.0
* [rake] >= 10.0.0
* [irb] ~> 1.0

## Install

1. Add the following to the `Gemfile`:

```ruby
gem 'rubygems-tasks', '~> 0.3', require: false
```

2. Add the following to the `Rakefile`:

```ruby
require 'rubygems/tasks'
Gem::Tasks.new
```

## Synopsis

```
rake build    # Builds all packages
rake console  # Spawns an Interactive Ruby Console
rake install  # Installs all built gem packages
rake release  # Performs a release
```

Perform a test build of the project and write all build artifacts to the
`pkg/` directory:

```
$ rake build
```

Jump into IRB with the Ruby library preloaded:

```
$ rake console
irb(main):001>
```

Build and install the Ruby gem locally:

```
$ rake install
```

Build, tag, and release a new version:

```
$ rake release
```

## Examples

Default configuration:

```ruby
require 'rubygems/tasks'
Gem::Tasks.new
```

Change the Ruby REPL for the `console` [Rake] task:

```ruby
Gem::Tasks.new do |tasks|
  tasks.console.command = 'pry'
end
```

Enable pushing gems to an internal [gem server] instead of [rubygems.org]:

```ruby
Gem::Tasks.new do |tasks|
  tasks.push.host = 'gems.company.internal'
end
```

Disable the `push` [Rake] task:

```ruby
Gem::Tasks.new(push: false)
```

Enable building `.tar.gz` and `.zip` source archives, in addition to the `.gem`
package:

```ruby
Gem::Tasks.new(build: {tar: true, zip: true})
```

Enable generating checksums and PGP signatures for built packages:

```ruby
Gem::Tasks.new(sign: {checksum: true, pgp: true})
```

Selectively defining specific [Rake] tasks:

```ruby
Gem::Tasks::Build::Tar.new
Gem::Tasks::SCM::Status.new
Gem::Tasks::SCM::Tag.new(format: 'REL-%s')
Gem::Tasks::Sign::Checksum.new
Gem::Tasks::Console.new
```

## Copyright

Copyright (c) 2011-2025 Hal Brodigan

See {file:LICENSE.txt} for details.

[Git]: https://git-scm.com/
[Mercurial]: https://www.mercurial-scm.org/
[SubVersion]: https://subversion.apache.org/

[Rake]: https://github.com/ruby/rake#readme

[rubygems.org]: https://rubygems.org/
[gem server]: https://github.com/rubygems/rubygems.org#readme

[ruby]: https://www.ruby-lang.org/
[rake]: https://rubygems.org/gems/rake
[irb]: https://rubygems.org/gems/irb
