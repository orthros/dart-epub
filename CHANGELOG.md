# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## Unreleased

## [2.1.0] - 2019-08-06
### Fixed
- Version 3 EPUBs can have a null Table of Contents
- Updated `pedantic` analysis options

## [2.0.7] - 2019-05-22
### Added
- Added example of using `epub` in a web page: `examples/web_ex`
### Fixed
- Fixed errors from pedantic analysis
### Changed
- Added pedantic analysis options

## [2.0.6] - 2019-05-22
### Fixed
- Fixed Issue #35: File cannot be opened if its path is url-encoded in the manifest
- Updated `examples/dart_ex` to have a README as well as use a locally stored file.

## [2.0.5] - 2019-05-16
### Changed
- Exposed `EpubChapterRef` to consumers.

## [2.0.4] - 2019-05-15
### Fixed
- Merged pull request #45
    - Fixes pana hits to make code more readable

## [2.0.3] - 2019-05-15
### Changed
- Raised `sdk` version constraint to 2.0.0
- Raised constraint on `async` to 3.0.0
### Fixed
- Merged pull request #40 by vblago. 
    - Fixes Undefined class 'XmlBuilder'

## [2.0.2] - 2018-08-07
### Changed
- Lowered sdk version constraint to 2.0.0-dev.61.0

## [2.0.1] - 2018-08-07
### Changed
- Formatted documents

## [2.0.0] - 2018-08-07
### Added
- Added support for writing Epubs back to Byte Arrays
- Tests for writing Epubs

### Changed
- Epub Readers and Writers now have their == operator and hashCode get-er overridden

### Fixed
- Fixed an issue when reading EpubContentFileRef

## [1.3.2] - 2018-08-01
### Changed
- Updates to Travis configuration and publishing

## [1.3.1] - 2018-08-01
### Changed
- Updates to Travis configuration and publishing
### Removed
- Removed unused variable `FilePath` from `EpubBook` and `EpubBookRef`

## [1.3.0] - 2018-08-01
### Added
- Package now supports Dart 2!
### Removed
- Removed support for Dart 1.2.21

## [1.2.10] - 2018-07-29
### Fixed
- Merged pull request #15 from ShadowJonathan/dev. 
    - Fixes issue with parsing schema by removing `opf:` namespace

## [1.2.9] - 2018-03-13
### Changed
- Ran code through `dartfmt` as per analysis by `pana`

## [1.2.8] - 2018-03-13
### Added
- Added unit tests for Images
### Changed
- Updated dependencies

## [1.2.7] - 2018-03-13
### Added
- Added upper limit of Dart version to 2.0.1

## [1.2.6] - 2018-03-12
### Added
- Added Support for Dart 2.0

## [1.2.5] - 2018-02-20
### Added
- A publish step in the travis deploy

## [1.2.4] - 2018-01-26
### Changed
- EnumFromString no longer uses the `mirrors` package to make this Flutter compatible by @MostafaAyesh 

## [1.2.3] - 2018-01-26
### Added
- This Changelog!

### Changed
- Author email

## [1.2.2] - 2017-01-26
### Changed
- Dependencies were updated to more permissive versions by @jarontai

### Added
- Example by @jarontai
- More Entities and types are exported by @jarontai

### Fixed
- Issue with case sensitivity in switch statements from @jarontai
- Issue with Async Loops from @jarontai

## [1.2.1] - 2017-05-28
### Fixed
- Made code in line with Dart styleguide
