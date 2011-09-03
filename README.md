# project-tasks

* [Source](http://github.com/ruby-ore/project-tasks)
* [Issues](http://github.com/ruby-ore/project-tasks/issues)
* [Email](mailto:postmodern.mod3 at gmail.com)

## Description

Project Tasks provides simple Rake tasks for managing and releasing RubyGem
projects.

## Features

* Provides tasks to build, install and push Gems to
  [rubygems.org](http://rubygems.org/).
* Supports Git, Mercurial and SubVersion.
* Provides the `console` task for jumping right into your code.
* **Does not** automatically modify or commit changes to your code.

## Requirements

* [scm](http://github.com/postmodern/scm) ~> 0.1.0

## Install

    $ gem install project-tasks

## Examples

    require 'project/tasks'
    Project::Tasks.new

Enable pushing gems to an in-house
[gemcutter](http://github.com/rubygems/gemcutter#readme) server:

    Project::Tasks.new(:gemcutter => 'internal.example.com')

Disable pushing gems:

    Project::Tasks.new(:gemcutter => false)

## Synopsis

    rake build            # Builds project-tasks-0.1.0
    rake console[script]  # Start IRB with all runtime dependencies loaded
    rake install          # Installs project-tasks-0.1.0
    rake install:deps     # Installs missing dependencies
    rake release          # Releases project-tasks-0.1.0
    rake spec             # Run RSpec code examples
    rake version          # Displays the current version
    rake yard             # Generate YARD Documentation

## Copyright

Copyright (c) 2011 Hal Brodigan

See {file:LICENSE.txt} for details.
