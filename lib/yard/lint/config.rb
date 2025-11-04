# frozen_string_literal: true

require 'yaml'
require_relative 'config_loader'

module Yard
  module Lint
    # Configuration object for YARD Lint
    class Config
      attr_reader :raw_config, :validators

      # Default YAML config file name
      DEFAULT_CONFIG_FILE = '.yard-lint.yml'

      # Default YARD options
      DEFAULT_OPTIONS = [].freeze

      # Default tags order (common YARD tag ordering)
      DEFAULT_TAGS_ORDER = %w[
        param
        option
        yield
        yieldparam
        yieldreturn
        return
        raise
        see
        example
        note
        todo
      ].freeze

      # Default tags to check for invalid types
      DEFAULT_INVALID_TAGS_NAMES = %w[
        param
        option
        return
        yieldreturn
      ].freeze

      # Default extra types that are allowed
      DEFAULT_EXTRA_TYPES = [].freeze

      # Default exclusion patterns (.git is always excluded)
      DEFAULT_EXCLUDE = ['\.git', 'vendor/**/*', 'node_modules/**/*'].freeze

      # Default fail severity level
      DEFAULT_FAIL_ON_SEVERITY = 'warning'

      # Valid severity levels for fail_on_severity
      VALID_SEVERITIES = %w[error warning convention never].freeze

      # Default allowed API values
      DEFAULT_ALLOWED_APIS = %w[public private internal].freeze

      # @param raw_config [Hash] raw configuration hash (new hierarchical format)
      def initialize(raw_config = {})
        @raw_config = raw_config
        @validators = build_validators_config

        yield self if block_given?
      end

      # Load configuration from a YAML file
      # @param path [String] path to YAML config file
      # @return [Yard::Lint::Config] configuration object
      def self.from_file(path)
        raise ArgumentError, "Config file not found: #{path}" unless File.exist?(path)

        # Load with inheritance support
        merged_yaml = ConfigLoader.load(path)

        new(merged_yaml)
      end

      # Search for and load config file from current directory upwards
      # @param start_path [String] directory to start searching from (default: current dir)
      # @return [Yard::Lint::Config, nil] config if found, nil otherwise
      def self.load(start_path: Dir.pwd)
        config_path = find_config_file(start_path)
        config_path ? from_file(config_path) : nil
      end

      # Find config file by searching upwards from start_path
      # @param start_path [String] directory to start searching from
      # @return [String, nil] path to config file if found
      def self.find_config_file(start_path)
        current = File.expand_path(start_path)
        root = File.expand_path('/')

        loop do
          config_path = File.join(current, DEFAULT_CONFIG_FILE)
          return config_path if File.exist?(config_path)

          break if current == root

          current = File.dirname(current)
        end

        nil
      end

      # YARD command-line options
      # @return [Array<String>] YARD options
      def options
        all_validators['YardOptions'] || DEFAULT_OPTIONS
      end

      # Global file exclusion patterns
      # @return [Array<String>] exclusion patterns
      def exclude
        all_validators['Exclude'] || DEFAULT_EXCLUDE
      end

      # Minimum severity level to fail on
      # @return [String] severity level (error, warning, convention, never)
      def fail_on_severity
        all_validators['FailOnSeverity'] || DEFAULT_FAIL_ON_SEVERITY
      end

      # Check if a validator is enabled
      # @param validator_name [String] full validator name (e.g., 'Tags/Order')
      # @return [Boolean] true if validator is enabled
      def validator_enabled?(validator_name)
        validator_config = validators[validator_name] || {}
        validator_config['Enabled'] != false # Default to true
      end

      # Get validator severity
      # @param validator_name [String] full validator name
      # @return [String] severity level for this validator
      def validator_severity(validator_name)
        validator_config = validators[validator_name] || {}
        validator_config['Severity'] || department_severity(validator_name)
      end

      # Get validator-specific exclude patterns
      # @param validator_name [String] full validator name
      # @return [Array<String>] exclusion patterns for this validator
      def validator_exclude(validator_name)
        validator_config = validators[validator_name] || {}
        validator_config['Exclude'] || []
      end

      # Get validator-specific configuration value
      # @param validator_name [String] full validator name
      # @param key [String] configuration key
      # @return [Object, nil] configuration value
      def validator_config(validator_name, key)
        validators.dig(validator_name, key)
      end

      # Setter methods for backward compatibility and programmatic configuration

      # Set YARD options
      # @param value [Array<String>] YARD options
      def options=(value)
        @raw_config['AllValidators'] ||= {}
        @raw_config['AllValidators']['YardOptions'] = value
      end

      # Set global exclude patterns
      # @param value [Array<String>] exclusion patterns
      def exclude=(value)
        @raw_config['AllValidators'] ||= {}
        @raw_config['AllValidators']['Exclude'] = value
      end

      # Set fail on severity level
      # @param value [String] severity level
      def fail_on_severity=(value)
        @raw_config['AllValidators'] ||= {}
        @raw_config['AllValidators']['FailOnSeverity'] = value
      end

      # Set tags order
      # @param value [Array<String>] tag order
      def tags_order=(value)
        @raw_config['Tags/Order'] ||= {}
        @raw_config['Tags/Order']['EnforcedOrder'] = value
        # Rebuild validators config to pick up the change
        @validators = build_validators_config
      end

      # Set invalid tags names
      # @param value [Array<String>] tag names to validate
      def invalid_tags_names=(value)
        @raw_config['Tags/InvalidTypes'] ||= {}
        @raw_config['Tags/InvalidTypes']['ValidatedTags'] = value
        @validators = build_validators_config
      end

      # Set extra types
      # @param value [Array<String>] extra type names
      def extra_types=(value)
        @raw_config['Tags/InvalidTypes'] ||= {}
        @raw_config['Tags/InvalidTypes']['ExtraTypes'] = value
        @validators = build_validators_config
      end

      # Set require API tags
      # @param value [Boolean] whether to require API tags
      def require_api_tags=(value)
        @raw_config['Tags/ApiTags'] ||= {}
        @raw_config['Tags/ApiTags']['Enabled'] = value
        @validators = build_validators_config
      end

      # Set allowed APIs
      # @param value [Array<String>] allowed API values
      def allowed_apis=(value)
        @raw_config['Tags/ApiTags'] ||= {}
        @raw_config['Tags/ApiTags']['AllowedApis'] = value
        @validators = build_validators_config
      end

      # Set validate abstract methods
      # @param value [Boolean] whether to validate abstract methods
      def validate_abstract_methods=(value)
        @raw_config['Semantic/AbstractMethods'] ||= {}
        @raw_config['Semantic/AbstractMethods']['Enabled'] = value
        @validators = build_validators_config
      end

      # Set validate option tags
      # @param value [Boolean] whether to validate option tags
      def validate_option_tags=(value)
        @raw_config['Tags/OptionTags'] ||= {}
        @raw_config['Tags/OptionTags']['Enabled'] = value
        @validators = build_validators_config
      end

      # Compatibility methods that map to validator config

      # @return [Array<String>] tag order from Tags/Order validator
      def tags_order
        validator_config('Tags/Order', 'EnforcedOrder') || ConfigLoader::VALIDATOR_DEFAULTS.dig('Tags/Order', 'EnforcedOrder')
      end

      # @return [Array<String>] validated tags from Tags/InvalidTypes validator
      def invalid_tags_names
        validator_config('Tags/InvalidTypes', 'ValidatedTags') || ConfigLoader::VALIDATOR_DEFAULTS.dig('Tags/InvalidTypes', 'ValidatedTags')
      end

      # @return [Array<String>] extra types from Tags/InvalidTypes validator
      def extra_types
        validator_config('Tags/InvalidTypes', 'ExtraTypes') || ConfigLoader::VALIDATOR_DEFAULTS.dig('Tags/InvalidTypes', 'ExtraTypes')
      end

      # @return [Boolean] whether API tags validator is enabled
      def require_api_tags
        validator_enabled?('Tags/ApiTags')
      end

      # @return [Array<String>] allowed API values from Tags/ApiTags validator
      def allowed_apis
        validator_config('Tags/ApiTags', 'AllowedApis') || ConfigLoader::VALIDATOR_DEFAULTS.dig('Tags/ApiTags', 'AllowedApis')
      end

      # @return [Boolean] whether abstract methods validator is enabled
      def validate_abstract_methods
        validator_enabled?('Semantic/AbstractMethods')
      end

      # @return [Boolean] whether option tags validator is enabled
      def validate_option_tags
        validator_enabled?('Tags/OptionTags')
      end

      # Allow hash-like access for convenience
      # @param key [Symbol, String] attribute name to access
      # @return [Object, nil] attribute value or nil if not found
      def [](key)
        respond_to?(key) ? send(key) : nil
      end

      private

      # Get AllValidators section
      # @return [Hash] AllValidators configuration
      def all_validators
        @raw_config['AllValidators'] || {}
      end

      # Build validators configuration from raw config
      # @return [Hash] validators configuration
      def build_validators_config
        config = {}

        # Start with defaults for all validators
        ConfigLoader::ALL_VALIDATORS.each do |validator_name|
          config[validator_name] = build_default_validator_config(validator_name)
        end

        # Apply department-level overrides
        ConfigLoader::DEPARTMENTS.each do |department, validator_names|
          next unless @raw_config[department]

          department_config = @raw_config[department]
          validator_names.each do |validator_name|
            if department_config.is_a?(Hash)
              config[validator_name] = merge_validator_config(
                config[validator_name],
                department_config
              )
            end
          end
        end

        # Apply validator-specific overrides
        @raw_config.each do |key, value|
          next unless key.include?('/') # Validator-specific config
          next unless ConfigLoader::ALL_VALIDATORS.include?(key)

          config[key] = merge_validator_config(config[key], value) if value.is_a?(Hash)
        end

        config
      end

      # Build default configuration for a validator
      # @param validator_name [String] full validator name
      # @return [Hash] default configuration
      def build_default_validator_config(validator_name)
        defaults = ConfigLoader::VALIDATOR_DEFAULTS[validator_name] || {}
        base = ConfigLoader::DEFAULT_VALIDATOR_CONFIG.dup

        base.merge(defaults).tap do |config|
          # Set department default severity if not specified
          config['Severity'] ||= department_severity(validator_name)
        end
      end

      # Get department severity for a validator
      # @param validator_name [String] full validator name
      # @return [String] severity level
      def department_severity(validator_name)
        department = validator_name.split('/').first
        ConfigLoader::DEPARTMENT_SEVERITIES[department] || 'warning'
      end

      # Merge validator configuration
      # @param base [Hash] base configuration
      # @param override [Hash] overriding configuration
      # @return [Hash] merged configuration
      def merge_validator_config(base, override)
        result = base.dup

        override.each do |key, value|
          # Skip metadata keys
          next if %w[Description StyleGuide VersionAdded VersionChanged].include?(key)

          if value.is_a?(Array) && result[key].is_a?(Array)
            result[key] = value # Array replacement
          elsif value.is_a?(Hash) && result[key].is_a?(Hash)
            result[key] = result[key].merge(value)
          else
            result[key] = value
          end
        end

        result
      end
    end
  end
end
