# Changelog

## 0.1.0 (Unreleased)

### Major Refactoring & Architecture Improvements

- [Refactoring] **Extract ResultBuilder class** - Separated result building logic from Runner for Single Responsibility Principle
  - Created new `Yard::Lint::ResultBuilder` class (126 lines)
  - Moved all result building, parser discovery, and composite handling logic
  - Runner now focused purely on orchestration (reduced from 189 to 91 lines, 52% smaller)
  - Improved testability with isolated result building tests

- [Refactoring] **Eliminate hardcoded special cases** - Replaced string-based validator checks with convention-based discovery
  - Before: 3 hardcoded string comparisons (`if validator_name == 'Warnings/Stats'`)
  - After: Zero hardcoded strings, fully convention-based architecture
  - Added marker interface (`combines_with`) for composite validators
  - Auto-discovers multi-parser validators by convention
  - Future validators require zero runner changes

- [Refactoring] **Convert Result instance methods to class attributes** - Simplified validator result configuration
  - Changed `default_severity`, `offense_type`, `offense_name` from instance to class-level
  - Implemented inheritance for class attributes (subclasses inherit from parent)
  - Made `build_message` private as implementation detail
  - All 9 validator Result classes updated

- [Refactoring] **Standardize code style** - Converted to `class << self` syntax throughout
  - Updated all 7 MessagesBuilder classes for consistency
  - User preference: avoid `def self.method` in favor of `class << self` blocks

- [Refactoring] **Improve method visibility** - Made internal-only methods private
  - Made `expand_path` private in `Yard::Lint` module
  - Made `load_config` private and refactored `exit_code` to use stored config
  - Made `build_message` private in `Results::Base`
  - Reduced public API surface area

- [Refactoring] **Remove Rake integration** - Simplified gem to focus on CLI
  - Deleted `lib/yard/lint/rake_task.rb` and corresponding spec
  - Removed from README and CHANGELOG
  - Principle: Keep it simple, less is more

- [Enhancement] **Remove error suppression** - Removed `rescue NameError, LoadError` in config loader
  - Errors now surface immediately for better debugging
  - Failed validator loading no longer silently skipped

### Test Coverage Improvements

- [Testing] **Add 49 new parser unit tests** - Comprehensive coverage for Stats validators
  - Created shared examples for OneLineBase parsers
  - Added specs for all 6 Stats parsers (UnknownTag, UnknownDirective, UnknownParameterName, etc.)
  - Each parser has 7-9 tests covering valid input, edge cases, and regex validation
  - Added `spec/support/one_line_base_parser_examples.rb` for reusability

- [Testing] **Add ResultBuilder unit tests** - 12 new tests for result building logic
  - Tests composite validator combination
  - Tests multi-parser discovery
  - Tests composite child skipping
  - Tests standard validators and config integration

- [Testing] **Test suite growth** - Increased from 173 to 222 examples (+28%)
  - All tests passing with 94.54% code coverage
  - Fast execution (~45 seconds for full suite)

### Code Quality Improvements

- [Performance] Use `filter_map` instead of `.map.compact` in ResultBuilder
  - Single-pass collection filtering for better performance

- [Style] Modernize path expansion - Use `__dir__` instead of `__FILE__`
  - Updated integration specs to modern Ruby idiom

- [Style] Fix octal literal notation - Use `0o755` instead of `0755`
  - Explicit octal notation prevents confusion with decimals

- [Style] Prefix unused parameters with underscore in test fixtures
  - Clarified intent in fixture files (intentionally unused params)

### Features & Enhancements

## 0.1.0 (Initial Features)
- [Feature] Initial release of YARD-Lint gem extracted from OffendingEngine
- [Feature] Add comprehensive YARD documentation validation
- [Feature] Add CLI tool (`yard-lint`) for running linter from command line
- [Feature] Add support for detecting undocumented classes, modules, and methods
- [Feature] Add support for detecting missing parameter documentation
- [Feature] Add support for validating tag type definitions
- [Feature] Add support for enforcing tag ordering conventions
- [Feature] Add support for validating boolean method documentation
- [Feature] Add YARD warning detection (unknown tags, invalid directives, etc.)
- [Feature] Add JSON and text output formats
- [Feature] Add configurable tag ordering
- [Feature] Add configurable extra type definitions
- [Feature] Add configurable YARD options
- [Feature] Add Ruby API for programmatic usage
- [Feature] Add Result object with offense categorization
- [Feature] Add three severity levels: error, warning, convention
- [Feature] Add YAML configuration file support (`.yard-lint.yml`)
- [Feature] Add automatic configuration file discovery in parent directories
- [Feature] Add file exclusion patterns with glob support
- [Feature] Add configurable exit code based on severity level (`fail_on_severity`)
- [Feature] Add quiet mode (`--quiet`) for minimal output
- [Feature] Add statistics summary (`--stats`) showing offense counts by severity
- [Feature] Add GitHub Actions CI workflow with multi-Ruby testing
- [Feature] Add GitHub Actions automated gem publishing workflow
- [Enhancement] Add comprehensive RSpec test suite
- [Enhancement] Add YARD documentation to all public APIs
- [Enhancement] Configure self-linting to ensure documentation quality
- [Feature] Add @api tag validation with `require_api_tags` and `allowed_apis` configuration
- [Feature] Add @abstract method validation with `validate_abstract_methods` configuration
- [Feature] Add @option hash documentation validation with `validate_option_tags` configuration
- [Enhancement] Replace manual requires with Zeitwerk for automatic code loading
- [Enhancement] Enable `validate_abstract_methods` and `validate_option_tags` by default for better DX
