# Changes

## [0.3.5](https://github.com/prantlf/v-debug/compare/v0.3.4...v0.3.5) (2024-08-11)

### Bug Fixes

* Replace deprecated index_u8_last with last_index_u8 ([0f300cb](https://github.com/prantlf/v-debug/commit/0f300cbf963869bdeaf8fd224b488f0a2b6f0ab0))

## [0.3.4](https://github.com/prantlf/v-debug/compare/v0.3.3...v0.3.4) (2023-12-11)

### Bug Fixes

* Adapt for V langage changes ([7351615](https://github.com/prantlf/v-debug/commit/735161537334219d142145b087b367f8d248aab6))

## [0.3.3](https://github.com/prantlf/v-debug/compare/v0.3.2...v0.3.3) (2023-09-17)

### Bug Fixes

* Detect improved colours on windows 10 ([8246e6a](https://github.com/prantlf/v-debug/commit/8246e6afc481260fe2e5ddc525af1557ff73bc28))

## [0.3.2](https://github.com/prantlf/v-debug/compare/v0.3.1...v0.3.2) (2023-09-17)

### Bug Fixes

* Replace WindowsHelpers.h with windows.h ([475ffa3](https://github.com/prantlf/v-debug/commit/475ffa386a106a2389bba19d1cb450a9f862131c))
* Remove profileapi.h ([e5ae9ee](https://github.com/prantlf/v-debug/commit/e5ae9ee0db6ddd29fd843534a04aff9c0590fef8))
* Remove the call to IsWindows10OrGreater ([28bc588](https://github.com/prantlf/v-debug/commit/28bc588ee8e8f2e0f303a6d9b87c9aedcfe0d60f))
* Use platform-specific path separator ([6ae39ee](https://github.com/prantlf/v-debug/commit/6ae39ee87e0ce39176abfa07b734d28fdfbfb196))

## [0.3.1](https://github.com/prantlf/v-debug/compare/v0.3.0...v0.3.1) (2023-09-17)

### Bug Fixes

* Fix windows performance counter usage ([0e06ebf](https://github.com/prantlf/v-debug/commit/0e06ebf9a5a32a21bb898fd68ff00ebe8840bac2))
* Do not call fcntl to check open stderr ([5a229e8](https://github.com/prantlf/v-debug/commit/5a229e861ed6ccf436440d7675a01103d80210cc))
* Name variables other tham module name, adapt to new v ([fd09411](https://github.com/prantlf/v-debug/commit/fd094118d3036ac5f65f35babcd1b3614fbe6a3c))

## [0.3.0](https://github.com/prantlf/v-debug/compare/v0.2.1...v0.3.0) (2023-08-13)

### Features

* Rename shorten_ext to shorten_within ([d08c2ea](https://github.com/prantlf/v-debug/commit/d08c2ead9f5ebe8582aea7021fa7982872d8f1f4))

### BREAKING CHANGES

Rename occurrences of `shorten_ext` to `shorten_within`.
A reluctant, annoying change. Make the API consistent with `prantlf.strutil`.

## [0.2.1](https://github.com/prantlf/v-debug/compare/v0.2.0...v0.2.1) (2023-08-11)

### Bug Fixes

* Use Time.nanosecond instead of the deprecated microsecond ([11f7c73](https://github.com/prantlf/v-debug/commit/11f7c730dad2cc0ff5f798820876d2c13b660832))

## [0.2.0](https://github.com/prantlf/v-debug/compare/v0.1.0...v0.2.0) (2023-08-11)

### Features

* Add functions for shortening strings ([c87cdb4](https://github.com/prantlf/v-debug/commit/c87cdb42f2fb83300a076893fc9d6ac50a1316d1))

## [0.1.0](https://github.com/prantlf/v-debug/compare/v0.0.2...v0.1.0) (2023-08-07)

### Features

* Allow constant global logger, show microseconds, no milliseconds ([76cfa3b](https://github.com/prantlf/v-debug/commit/76cfa3b818ec236de29e8fbfeefae89cbdac61ec))

## [0.0.2](https://github.com/prantlf/v-debug/compare/v0.0.1...v0.0.2) (2023-07-21)

### Features

* Print relative directories ([0758e3a](https://github.com/prantlf/v-debug/commit/0758e3aafa915601fadb14546a683be47cab3c2c))

## 0.0.1 (2023-07-17)

Initial release.
