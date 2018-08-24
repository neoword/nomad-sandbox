# CHANGELOG.md
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog]
and this project adheres to [Semantic Versioning].

## [v0.4] - Unreleased
### Changed
* Fixed trailing comma issue (#15)

## [v0.3] - 20180824
### Added
* Added metadata for docker-registry (#13)
* Added config for docker-registry (#13)

### Changed
* CHANGELOG.md is [Keep a Changelog] compliant (#12)

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

[v0.3]: https://github.com/neoword/nomad-sandbox/compare/v0.2...v0.3
[v0.2]: https://github.com/neoword/nomad-sandbox/compare/v0.1...v0.2
[Keep a Changelog]: http://keepachangelog.com/en/1.0.0/
[Semantic Versioning]: http://semver.org/spec/v2.0.0.html
