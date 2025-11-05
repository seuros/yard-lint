# frozen_string_literal: true

module Yard
  module Lint
    # Builds result objects from raw validator output
    # Handles standard validators, multi-parser validators, and composite validators
    class ResultBuilder
      attr_reader :config

      # @param config [Config] configuration object
      def initialize(config)
        @config = config
      end

      # Build result for a single validator
      # Uses convention-based discovery to handle all validator types uniformly
      # @param validator_name [String] validator name (e.g., 'Tags/Order')
      # @param raw [Hash] raw results from all validators
      # @return [Results::Base, nil] result object or nil if no offenses
      def build(validator_name, raw)
        validator_module = ConfigLoader.validator_module(validator_name)
        return nil unless validator_module

        # Skip if this validator is a child of a composite
        return nil if composite_child?(validator_name)

        # Handle composite validators (those that combine multiple validators)
        if validator_module.respond_to?(:combines_with)
          return build_composite_result(validator_module, raw)
        end

        # Handle standard validators (single or multi-parser)
        build_standard_result(validator_module, raw)
      end

      private

      # Check if a validator is a child of a composite validator
      # @param validator_name [String] validator name to check
      # @return [Boolean] true if this is a composite child
      def composite_child?(validator_name)
        ConfigLoader::ALL_VALIDATORS.any? do |parent_name|
          parent_module = ConfigLoader.validator_module(parent_name)
          next unless parent_module

          if parent_module.respond_to?(:combines_with)
            parent_module.combines_with.include?(validator_name)
          else
            false
          end
        end
      end

      # Build result for a composite validator (combines multiple validators)
      # @param validator_module [Module] validator module
      # @param raw [Hash] raw results
      # @return [Results::Base, nil] composite result or nil
      def build_composite_result(validator_module, raw)
        # Collect all validators to combine (parent + children)
        child_validators = validator_module.combines_with.filter_map do |child_name|
          ConfigLoader.validator_module(child_name)
        end
        all_validators = [validator_module] + child_validators

        # Parse output from all validators
        combined = all_validators.flat_map do |mod|
          parse_validator_output(mod, raw)
        end

        return nil if combined.empty?

        validator_module::Result.new(combined, config)
      end

      # Build result for a standard validator (single or multi-parser)
      # Auto-detects multi-parser validators by discovering parser classes
      # @param validator_module [Module] validator module
      # @param raw [Hash] raw results
      # @return [Results::Base, nil] result or nil
      def build_standard_result(validator_module, raw)
        return nil unless raw[validator_module.id]

        stdout = raw.dig(validator_module.id, :stdout)
        return nil unless stdout

        # Discover all parser classes in the validator module
        parsers = discover_parsers(validator_module)
        return nil if parsers.empty?

        # Parse output with all parsers (single or multiple)
        parsed = parsers.flat_map { |parser| parser.new.call(stdout) }
        return nil if parsed.nil? || parsed.empty?

        validator_module::Result.new(parsed, config)
      end

      # Parse output from a validator module
      # @param validator_module [Module] validator module
      # @param raw [Hash] raw results
      # @return [Array<Hash>] parsed offenses
      def parse_validator_output(validator_module, raw)
        return [] unless raw[validator_module.id]

        stdout = raw.dig(validator_module.id, :stdout)
        return [] unless stdout

        parsers = discover_parsers(validator_module)
        parsers.flat_map { |parser| parser.new.call(stdout) }
      end

      # Auto-discover parser classes in a validator module
      # Finds all classes that inherit from Parsers::Base
      # @param validator_module [Module] validator module to search
      # @return [Array<Class>] array of parser classes
      def discover_parsers(validator_module)
        validator_module.constants
                        .map { |const_name| validator_module.const_get(const_name) }
                        .select { |const| const.is_a?(Class) }
                        .select { |klass| klass < Parsers::Base }
                        .reject do |klass|
          [validator_module::Validator, validator_module::Result].include?(klass)
        end
      end
    end
  end
end
