# rubygems-tasks

* [Source](https://github.com/postmodern/rubygems-tasks)
* [Issues](https://github.com/postmodern/rubygems-tasks/issues)
* [Email](mailto:postmodern.mod3 at gmail.com)

## Description

rubygems-tasks provides agnostic and unobtrusive Rake tasks for building,
installing and releasing Ruby Gems.

    require 'rubygems/tasks'
    Gem::Tasks.new

## Philosophy

The Rake tasks which you use to manage a Ruby project _should not_ be coupled
to the project generator which you used to create the project.
Project generators have _nothing_ to do with the Rake tasks used to build,
install and release a Ruby project.

Recently, many Ruby Developers began creating Ruby projects by hand,
building/releasing RubyGems using `gem build` / `gem push`. Sometimes this
resulted in RubyGems being released with uncommitted changes, or the developer
forgetting to tag the release. Ruby Developers should have access to
_agnostic_ and _unobtrusive_ Rake tasks, to _automate_ the release process.
This is what rubygems-tasks seeks to provide.

## Features

* Provides tasks to build, install and push gems to [rubygems.org].
  * Loads all project metadata from the `.gemspec` file.
  * Supports loading multiple `.gemspec` files.
  * Supports pushing gems to alternate [Gemcutter] servers.
* Supports optionally building `.tar.gz` and `.zip` archives.
  * `build:tar`
  * `build:zip`
* Supports [Git], [Mercurial] and [SubVersion] Source-Code-Managers
  (SCMs).
  * Supports creating PGP signed Git/Mercurial tags.
* Provides optional `sign` tasks for package integrity:
  * `sign:checksum`
  * `sign:pgp`
* Provides a `console` task, for jumping right into your code.
* Defines task aliases for users coming from [Jeweler] or [Hoe].
* ANSI coloured messages!

## Anti-Features

* **Does not** parse project metadata from the README or the ChangeLog.
* **Does not** generate or modify code.
* **Does not** automatically commit changes.
* **Does not** inject dependencies into gems.
* **Zero** dependencies.

## Install

    $ gem install rubygems-tasks

## Examples

Specifying an alternate Ruby Console to run:

    Gem::Tasks.new do |tasks|
      tasks.console.command = 'pry'
    end

Enable pushing gems to an in-house [Gemcutter] server:

    Gem::Tasks.new do |tasks|
      tasks.push.host = 'gems.company.com'
    end

Disable the `push` task:

    Gem::Tasks.new(:push => false)

Enable building `.tar.gz` and `.zip` archives:

    Gem::Tasks.new(:build => {:tar => true, :zip => true})

Enable Checksums and PGP signatures for built packages:

    Gem::Tasks.new(:sign => {:checksum => true, :pgp => true})

Selectively defining tasks:

    Gem::Build::Tar.new
    Gem::SCM::Status.new
    Gem::SCM::Tag.new(:format => 'REL-%s')
    Gem::Sign::Checksum.new
    Gem::Console.new

## Synopsis

    rake build    # Builds all packages
    rake console  # Spawns an Interactive Ruby Console
    rake install  # Installs all built gem packages
    rake release  # Performs a release

## Copyright

Copyright (c) 2011-2013 Hal Brodigan

See {file:LICENSE.txt} for details.

[Git]: http://git-scm.com/
[Mercurial]: http://mercurial.selenic.com/
[SubVersion]: http://subversion.tigris.org/

[Jeweler]: https://github.com/technicalpickles/jeweler#readme
[Hoe]: https://github.com/seattlerb/hoe#readme

[rubygems.org]: https://rubygems.org/
[Gemcutter]: https://github.com/rubygems/rubygems.org#readme
