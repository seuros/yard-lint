# frozen_string_literal: true

module Yard
  module Lint
    # Main runner class that orchestrates the YARD validation process
    class Runner
      attr_reader :config, :selection

      # @param selection [Array<String>] array with ruby files to check
      # @param config [Yard::Lint::Config] configuration object
      def initialize(selection, config = Config.new)
        @selection = Array(selection).flatten
        @config = config
        @result_builder = ResultBuilder.new(config)
      end

      # Runs all validators and returns a Result object
      # @return [Yard::Lint::Result] result object with all offenses
      def run
        raw_results = run_validators
        parsed_results = parse_results(raw_results)
        build_result(parsed_results)
      end

      private

      # Run all validators
      # Automatically runs all validators from ConfigLoader::ALL_VALIDATORS if enabled
      # @return [Hash] hash with raw results from all validators
      def run_validators
        results = {}

        # Iterate through all registered validators
        ConfigLoader::ALL_VALIDATORS.each do |validator_name|
          # Check if validator is enabled in config
          next unless config.validator_enabled?(validator_name)

          # Get the validator namespace and config
          validator_namespace = ConfigLoader.validator_module(validator_name)
          validator_cfg = ConfigLoader.validator_config(validator_name)

          # Run the validator if it has a module
          # (validators with modules have Validator classes)
          if validator_namespace
            run_and_store_validator(validator_namespace, validator_cfg, results)
          end
        end

        results
      end

      # Run a validator and store its result using the module's ID
      # @param validator_namespace [Module] validator namespace module (e.g., Validators::Tags::Order)
      # @param validator_config [Class] validator config class
      # @param results [Hash] hash to store results in
      def run_and_store_validator(validator_namespace, validator_config, results)
        results[validator_config.id] = run_validator(validator_namespace::Validator)
      end

      # Run a single validator
      # @param validator_class [Class] validator class to instantiate and run
      # @return [Hash] hash with stdout, stderr and exit_code keys
      def run_validator(validator_class)
        validator_class.new(config, selection).call
      end

      # Parse raw results from validators and create Result objects
      # Delegates result building to ResultBuilder
      # @param raw [Hash] hash with raw results from all validators
      # @return [Array<Results::Base>] array of Result objects
      def parse_results(raw)
        results = []

        # Iterate through all registered validators and build results
        ConfigLoader::ALL_VALIDATORS.each do |validator_name|
          next unless config.validator_enabled?(validator_name)

          result = @result_builder.build(validator_name, raw)
          results << result if result
        end

        results
      end

      # Build final result object
      # @param results [Array<Results::Base>] array of validator result objects
      # @return [Results::Aggregate] aggregate result object
      def build_result(results)
        Results::Aggregate.new(results, config)
      end
    end
  end
end
