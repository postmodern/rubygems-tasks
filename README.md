# rubygems-tasks

* [Source](https://github.com/ruby-ore/rubygems-tasks)
* [Issues](https://github.com/ruby-ore/rubygems-tasks/issues)
* [Email](mailto:postmodern.mod3 at gmail.com)

## Description

Tasks provides simple Rake tasks for managing and releasing RubyGem projects.

## Features

* Provides tasks to build, install and push Gems to
  [rubygems.org](https://rubygems.org/).
* Supports Git (`git`), Mercurial (`hg`) and SubVersion (`svn).
* Provides the `console` task for jumping right into your code.
* **Does not** automatically modify or commit changes to your code.

## Install

    $ gem install rubygems-tasks

## Examples

    require 'rubygems/tasks'
    Gem::Tasks.new

Enable pushing gems to an in-house
[gemcutter](https://github.com/rubygems/gemcutter#readme) server:

    Gem::Tasks.new do |tasks|
      tasks.push.host = 'gems.company.come'
    end

Disable the `push` task:

    Gem::Tasks.new(:push => false)

Enable Checksums and PGP signatures of built packages:

    Gem::Tasks.new(:sign => {:checksum => true, :pgp => true})

Selectively define tasks:

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
