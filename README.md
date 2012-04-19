# rubygems-tasks

* [Source](https://github.com/ruby-ore/rubygems-tasks)
* [Issues](https://github.com/ruby-ore/rubygems-tasks/issues)
* [Email](mailto:postmodern.mod3 at gmail.com)

## Description

Gem::Tasks provides simple Rake tasks for managing and releasing Ruby gems.

## Features

* Provides tasks to build, install and push gems to
  [rubygems.org](https://rubygems.org/).
  * Supports pushing gems to alternate [RubyGems](https://github.com/rubygems/rubygems.org#readme)
    servers.
* Supports optionally building `.tar.gz` and `.zip` archives.
* Supports Git (`git`), Mercurial (`hg`) and SubVersion (`svn`)
  Source-Code-Managers (SCMs).
* Provides optional `sign` tasks for package integrity:
  * `sign:checksum`
  * `sign:pgp`
* Provides a `console` task, for jumping right into your code.
* Defines task aliases for users coming from [Jeweler](https://github.com/technicalpickles/jeweler#readme)
  or [Hoe](https://github.com/seattlerb/hoe#readme).
* ANSI coloured messages!

## Anti-Features

* **Does not** generate or modify code.
* **Does not** automatically commit changes.
* **Does not** inject dependencies into gems.
* **Zero** dependencies.

## Install

    $ gem install rubygems-tasks

## Examples

    require 'rubygems/tasks'
    Gem::Tasks.new

Specifying an alternate Ruby Console to run:

    Gem::Tasks.new do |tasks|
      tasks.console.command = 'pry'
    end

Enable pushing gems to an in-house
[RubyGems](https://github.com/rubygems/rubygems.org#readme) server:

    Gem::Tasks.new do |tasks|
      tasks.push.host = 'gems.company.come'
    end

Disable the `push` task:

    Gem::Tasks.new(:push => false)

Enable Checksums and PGP signatures for built packages:

    Gem::Tasks.new(:sign => {:checksum => true, :pgp => true})

Selectively defining tasks:

    Gem::SCM::Status.new
    Gem::SCM::Tag.new(:format => 'REL-%s')
    Gem::Build::Tar.new
    Gem::Sign::Checksum.new
    Gem::Console.new

## Synopsis

    rake build    # Builds all packages
    rake console  # Spawns an Interactive Ruby Console
    rake install  # Installs all built gem packages
    rake release  # Performs a release

## Copyright

Copyright (c) 2011-2012 Hal Brodigan

See {file:LICENSE.txt} for details.
