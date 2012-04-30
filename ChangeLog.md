### 0.2.1 / 2012-04-29

* Overrode the `FileUtils.fu_output_message` to call
  {Gem::Tasks::Printing#debug}.
* Added `@api semipublic` tags to mark the semi-public API.
* Fixed a spelling error.

#### console

* No longer run `bundle console`, since it is not the same as running
  `bundle exec irb -Ilib -rfoo/bar.rb`.

#### scm:status

* Will display the human-readable status, if the repository is dirty.
* Hooks into the `validate` task.

#### scm:push

* Depends on the `validate` task.

#### scm:tag

* Depends on the `validate` task.

#### build:*

* All `build:*` tasks now depend on the `validate` task.

#### push

* Depends on the `validate` task.

### 0.2.0 / 2012-04-27

* Removed `Gem::Tasks::Task.task_name`.

#### scm:status

* Now ignores untracked files.
* Will prevent any packages from being built, if the repository is dirty.

#### scm:tag

* Now create `v` prefixed version tags by default.
* Now supports creating PGP signed Git/Mercurial tags.
* {Gem::Tasks::SCM::Tag#initialize} now accepts the `:sign` option,
  for enabling/disabling tag signing on a per-project basis.
* Added {Gem::Tasks::SCM::Tag#sign?} and {Gem::Tasks::SCM::Tag#sign=}.

### 0.1.2 / 2012-04-26

#### scm:push

* Now runs `git push` then `git push --tags`.

### 0.1.1 / 2012-04-26

#### console

* require `rubygems` on Ruby 1.8.
* require the first `lib/` file to load the project.

#### sign:pgp

* Now creates ASCII armored signatures.

### 0.1.0 / 2012-04-24

* Initial release:
  * Added {Gem::Tasks::Project}.
  * Added {Gem::Tasks::Printing}.
  * Added {Gem::Tasks::Task}.
  * Added {Gem::Tasks::Build::Task}.
  * Added {Gem::Tasks::Build::Gem}.
  * Added {Gem::Tasks::Build::Tar}.
  * Added {Gem::Tasks::Build::Zip}.
  * Added {Gem::Tasks::SCM::Push}.
  * Added {Gem::Tasks::SCM::Status}.
  * Added {Gem::Tasks::SCM::Tag}.
  * Added {Gem::Tasks::Sign::Task}.
  * Added {Gem::Tasks::Sign::Checksum}.
  * Added {Gem::Tasks::Sign::PGP}.
  * Added {Gem::Tasks::Console}.
  * Added {Gem::Tasks::Install}.
  * Added {Gem::Tasks::Push}.
  * Added {Gem::Tasks::Release}.
  * Added {Gem::Tasks}.
