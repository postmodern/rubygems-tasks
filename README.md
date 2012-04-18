# rubygems-tasks

* [Source](https://github.com/ruby-ore/rubygems-tasks)
* [Issues](https://github.com/ruby-ore/rubygems-tasks/issues)
* [Email](mailto:postmodern.mod3 at gmail.com)

## Description

Tasks provides simple Rake tasks for managing and releasing RubyGem projects.

## Features

* Provides tasks to build, install and push Gems to
  [rubygems.org](https://rubygems.org/).
* Supports Git, Mercurial and SubVersion.
* Provides the `console` task for jumping right into your code.
* **Does not** automatically modify or commit changes to your code.

## Install

    $ gem install rubygems-tasks

## Examples

    require 'rubygems/tasks'
    Gem::Tasks.new

Enable pushing gems to an in-house
[gemcutter](https://github.com/rubygems/gemcutter#readme) server:

    Gem::Tasks.new(:push => {:host => 'internal.example.com'})

Disable the `push` task:

    Gem::Tasks.new(:push => false)

## Synopsis

    rake build:gem[name]  # Builds all gem packages
    rake build:tar[name]  # Builds all tar.gz packages
    rake build:zip[name]  # Builds all zip packages
    rake console[name]    # Spawns an Interactive Ruby Console (irb)
    rake install[name]    # Installs all built gem packages
    rake push[name]       # Pushes all gems
    rake release          # Performs a release

## Copyright

Copyright (c) 2011-2012 Hal Brodigan

See {file:LICENSE.txt} for details.
