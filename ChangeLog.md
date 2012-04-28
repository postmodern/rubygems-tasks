### 0.2.0 / 2012-04-27

* {Gem::Tasks::SCM::Status} now ignores untracked files.
* {Gem::Tasks::SCM::Status} will prevent any packages from being built,
  if the repository is dirty.
* {Gem::Tasks::SCM::Tag} now supports creating PGP signed Git/Mercurial tags.
* Added {Gem::Tasks::SCM::Tag#sign?} and {Gem::Tasks::SCM::Tag#sign=}.
* {Gem::Tasks::SCM::Tag#initialize} now accepts the `:sign` option.

### 0.1.2 / 2012-04-26

* {Gem::Tasks::SCM::Push} now runs `git push` then `git push --tags`.

### 0.1.1 / 2012-04-26

* {Gem::Tasks::Sign::PGP} now creates ASCII armored signatures.
* {Gem::Tasks::Console}
  * require `rubygems` on Ruby 1.8.
  * require the first `lib/` file to load the project.

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
