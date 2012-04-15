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

    Gem::Tasks.new(:gemcutter => 'internal.example.com')

Disable pushing gems:

    Gem::Tasks.new(:gemcutter => false)

## Synopsis

    rake build            # Builds project-0.1.0
    rake console[script]  # Start IRB with all runtime dependencies loaded
    rake install          # Installs project-0.1.0
    rake install:deps     # Installs missing dependencies
    rake release          # Releases project-0.1.0
    rake version          # Displays the current version

## Copyright

Copyright (c) 2011-2012 Hal Brodigan

See {file:LICENSE.txt} for details.
