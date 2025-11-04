# frozen_string_literal: true

module Yard
  module Lint
    module Validators
      module Documentation
        # UndocumentedMethodArguments validator module
        module UndocumentedMethodArguments
          class << self
            # Unique identifier for this validator
            # @return [Symbol] validator identifier
            def id
              :undocumented_method_arguments
            end

            # Default configuration for this validator
            # @return [Hash] default configuration
            def defaults
              {
                'Enabled' => true,
                'Severity' => 'warning'
              }
            end
          end
        end
      end
    end
  end
end
