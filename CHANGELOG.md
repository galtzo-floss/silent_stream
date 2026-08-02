# Changelog

[![SemVer 2.0.0][📌semver-img]][📌semver] [![Keep-A-Changelog 1.0.0][📗keep-changelog-img]][📗keep-changelog]

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog][📗keep-changelog],
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html),
and [yes][📌major-versions-not-sacred], platform and engine support are part of the [public API][📌semver-breaking].
Please file a bug if you notice a violation of semantic versioning.

[📌semver]: https://semver.org/spec/v2.0.0.html
[📌semver-img]: https://img.shields.io/badge/semver-2.0.0-FFDD67.svg?style=flat
[📌semver-breaking]: https://github.com/semver/semver/issues/716#issuecomment-869336139
[📌major-versions-not-sacred]: https://tom.preston-werner.com/2022/05/23/major-version-numbers-are-not-sacred.html
[📗keep-changelog]: https://keepachangelog.com/en/1.0.0/
[📗keep-changelog-img]: https://img.shields.io/badge/keep--a--changelog-1.0.0-FFDD67.svg?style=flat

## [Unreleased]

### Added

- kettle-jem-template-20260720-005 - README Support & Community links now
  include RubyForum.
- kettle-jem-template-20260726-001 - Projects now include YARD lint
  configuration and documentation dependencies so documentation issues fail
  before generated docs are refreshed.
- kettle-jem-template-20260727-001 - Spec harness documentation now lists the
  RSpec helpers provided by `kettle-test`.

### Changed

- kettle-jem-template-20260716-002 - Gemspecs now ship fewer repository-only
  files, reducing package noise for downstream packagers.
- kettle-jem-template-20260720-002 - Development Gemfiles now use the released
  `tree_sitter_language_pack` gem 1.13.3 or newer by default.
- kettle-jem-template-20260725-002 - Version specs now use `anonymous_loader` to
  cover `version.rb` without redefining constants, or are removed when version
  specs are not managed for the project.
- kettle-jem-template-20260728-001 - Generated Ruby workflows now use clearer
  setup-ruby-flash planning and can prepare appraisal-only jobs without
  installing the main Gemfile bundle.
- kettle-jem-template-20260801-001 - Generated README gem dashboard links now
  use ClickGems instead of BestGems.

### Deprecated

### Removed

### Fixed

- kettle-jem-template-20260720-003 - StructuredMerge Git diff driver config now
  uses the installed `smorg-rb` driver command.
- kettle-jem-template-20260725-001 - Release pull request branches beginning
  with `feature/release` now run JRuby and TruffleRuby workflows.
- kettle-jem-template-20260726-002 - Generated version files now document their
  version namespace and constants, reducing warning-only YARD lint output.
- kettle-jem-template-20260726-003 - Coverage upload steps now treat Coveralls,
  QLTY, and Codecov as optional, so provider outages do not fail CI when local
  coverage thresholds still pass.
- kettle-jem-template-20260728-002 - Generated RuboCop configs now ignore the
  same `gemfiles/vendor/bundle` tree as `.gitignore`, so vendored dependency
  installs are not reported as project lint debt.
- kettle-jem-template-20260728-005 - VersionGem bootstrap now creates the
  missing canonical version spec when a project only has shim namespace version
  specs.
- kettle-jem-template-20260730-001 - Gemspec package file enumeration now runs
  relative to the gemspec directory, so release package contents stay correct
  even when the gemspec is loaded from another working directory.
- kettle-jem-template-20260801-002 - Generated RSpec helpers now normalize
  managed configuration block bindings structurally, preventing mixed block
  parameter names from producing invalid configuration after a merge.
- kettle-jem-template-20260801-003 - Generated project metadata and
  documentation now normalize configured underscore hostnames to valid
  hyphenated hostnames.
- kettle-jem-template-20260801-004 - Generated organization README logos now
  use GitHub's stable organization avatar endpoint instead of assuming a
  matching Galtzo-hosted asset exists.
- kettle-jem-template-20260802-001 - Devcontainer JSON files now merge as JSONC,
  preserving comments and trailing commas during template updates.

- kettle-jem-template-20260728-003 - Generated dep-heads workflows now run
  TruffleRuby jobs with current RubyGems and Bundler, avoiding setup failures
  before the test suite starts.
- kettle-jem-template-20260728-004 - Generated dep-heads workflows now use the
  setup-ruby Bundler install path for direct appraisal Gemfiles, avoiding rv
  lockfile parser failures on Git and path dependencies.
- kettle-jem-template-20260729-001 - Generated JRuby 9.4 workflows now use the
  legacy manual bundle install path, avoiding setup-time Bundler full-index
  failures against `gem.coop`.

### Security

## [1.0.12] - 2025-08-21
- TAG: [v1.0.12][1.0.12t]
- COVERAGE: 100.00% -- 80/80 lines in 2 files
- BRANCH COVERAGE: 100.00% -- 21/21 branches in 2 files
- 50.00% documented
### Added
- RBS types
- More YARD documentation
- Published docs site: [silent-stream.galtzo.com](https://silent-stream.galtzo.com)
- Complete test coverage for lines and branches at 100%
- Testing of many scenarios via appraisal2 gem
### Fixed
-  TypeError: can't convert Tempfile into StringIO
### Removed
- CI for JRuby 9.1, 9.2 (EOL)
- CI for TruffleRuby 22.3 (EOL) & head because failing in ways that can't be fixed from this project

## [1.0.11] - 2025-05-16
- TAG: [v1.0.11][1.0.11t]
- COVERAGE: 88.06% -- 59/67 lines in 2 files
- BRANCH COVERAGE: 30.00% -- 3/10 branches in 2 files
- 50.00% documented
### Changed
- Reduced minimum version of logger dependency to 1.2
  - To help with testing old libraries, or newer libraries that still support old libraries
### Fixed
- Code Coverage setup in CI

## [1.0.10] - 2025-05-05
- TAG: [v1.0.10][1.0.10t]
- COVERAGE:  47.76% -- 32/67 lines in 2 files
- BRANCH COVERAGE:  10.00% -- 1/10 branches in 2 files
- 50.00% documented
### Changed
- SilentStream::Version => SilentStream::Version::VERSION
  - Allows test coverage to be tracked for version.rb

## [1.0.9] - 2025-05-05
- TAG: [v1.0.9][1.0.9t]
- COVERAGE:  40.62% -- 26/64 lines in 2 files
- BRANCH COVERAGE:  10.00% -- 1/10 branches in 2 files
- 54.55% documented
### Added
- Releases will be signed by my key that expires 2045-04-29
- Allow unsigned gem builds (for linux distros)
  - In the ENV set `SKIP_GEM_SIGNING` to any value
- Compatibility with Ruby 3.5
  - Make `logger` a direct dependency, since it is removed from stdlib in Ruby 3.5
- Expanded CI test matrix to include JRuby, TruffleRuby, and MRI 2.3+, including heads

## [1.0.8] - 2024-03-20
- TAG: [v1.0.8][1.0.8t]

## [1.0.7] - 2024-03-20
- TAG: [v1.0.7][1.0.7t]

## [1.0.6] - 2020-02-25
- TAG: [v1.0.6][1.0.6t]

## [1.0.5] - 2018-10-10
- TAG: [v1.0.5][1.0.5t]

## [1.0.4] - 2018-10-06
- TAG: [v1.0.4][1.0.4t]

## [1.0.3] - 2018-09-25
- TAG: [v1.0.3][1.0.3t]

## [1.0.2] - 2018-09-25
- TAG: [v1.0.2][1.0.2t]

## [1.0.1] - 2018-09-23
- TAG: [v1.0.1][1.0.1t]

## [1.0.0] - 2018-09-23
- TAG: [v1.0.0][1.0.0t]

[Unreleased]: https://gitlab.com/galtzo-floss/silent_stream/-/compare/v1.0.12...HEAD
[1.0.12]: https://gitlab.com/galtzo-floss/silent_stream/-/compare/v1.0.11...v1.0.12
[1.0.12t]: https://gitlab.com/galtzo-floss/silent_stream/-/tags/v1.0.12
[1.0.11]: https://gitlab.com/galtzo-floss/silent_stream/-/compare/v1.0.10...v1.0.11
[1.0.11t]: https://gitlab.com/galtzo-floss/silent_stream/-/tags/v1.0.11
[1.0.10]: https://gitlab.com/galtzo-floss/silent_stream/-/compare/v1.0.9...v1.0.10
[1.0.10t]: https://gitlab.com/galtzo-floss/silent_stream/-/tags/v1.0.10
[1.0.9]: https://gitlab.com/galtzo-floss/silent_stream/-/compare/v1.0.8...v1.0.9
[1.0.9t]: https://gitlab.com/galtzo-floss/silent_stream/-/tags/v1.0.9
[1.0.8]: https://gitlab.com/galtzo-floss/silent_stream/-/compare/v1.0.7...v1.0.8
[1.0.8t]: https://gitlab.com/galtzo-floss/silent_stream/-/tags/v1.0.8
[1.0.7]: https://gitlab.com/galtzo-floss/silent_stream/-/compare/v1.0.5...v1.0.7
[1.0.7t]: https://gitlab.com/galtzo-floss/silent_stream/-/tags/v1.0.7
[1.0.6]: https://rubygems.org/gems/silent_stream/versions/1.0.6
[1.0.6t]: https://gitlab.com/galtzo-floss/silent_stream/-/tags/v1.0.6
[1.0.5]: https://gitlab.com/galtzo-floss/silent_stream/-/tags/v1.0.5
[1.0.5t]: https://gitlab.com/galtzo-floss/silent_stream/-/tags/v1.0.5
[1.0.4]: https://rubygems.org/gems/silent_stream/versions/1.0.4
[1.0.4t]: https://gitlab.com/galtzo-floss/silent_stream/-/tags/v1.0.4
[1.0.3]: https://rubygems.org/gems/silent_stream/versions/1.0.3
[1.0.3t]: https://gitlab.com/galtzo-floss/silent_stream/-/tags/v1.0.3
[1.0.2]: https://rubygems.org/gems/silent_stream/versions/1.0.2
[1.0.2t]: https://gitlab.com/galtzo-floss/silent_stream/-/tags/v1.0.2
[1.0.1]: https://rubygems.org/gems/silent_stream/versions/1.0.1
[1.0.1t]: https://gitlab.com/galtzo-floss/silent_stream/-/tags/v1.0.1
[1.0.0]: https://rubygems.org/gems/silent_stream/versions/1.0.0
[1.0.0t]: https://gitlab.com/galtzo-floss/silent_stream/-/tags/v1.0.0
