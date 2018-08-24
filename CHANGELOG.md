# CHANGELOG.md
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog]
and this project adheres to [Semantic Versioning].

## [v0.3] Unreleased
### Changed
* CHANGELOG.md is [Keep a Changelog] compliant

## [v0.2] - 20180717
### Added
* Added metadata for kafka, stream-registry (#8)

### Changed
* Separated out zookeeper config
* Refactored so that other meta data can be done on a per IP/node/client basis

### Removed
* Removed some unnecessary scripts (#7)

## v0.1 - 20180706
### Added
* Initial version
* Moved zookeeper.hcl to confluent-sandbox (#4)

[v0.2]: https://github.com/neoword/nomad-sandbox/compare/v0.1...v0.2
[Keep a Changelog]: http://keepachangelog.com/en/1.0.0/
[Semantic Versioning]: http://semver.org/spec/v2.0.0.html
