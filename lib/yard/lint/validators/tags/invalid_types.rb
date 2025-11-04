# frozen_string_literal: true

module Yard
  module Lint
    module Validators
      module Tags
        # InvalidTypes validator module
        module InvalidTypes
          class << self
            # Unique identifier for this validator
            # @return [Symbol] validator identifier
            def id
              :invalid_types
            end

            # Default configuration for this validator
            # @return [Hash] default configuration
            def defaults
              {
                'Enabled' => true,
                'Severity' => 'warning',
                'ValidatedTags' => %w[param option return yieldreturn],
                'ExtraTypes' => []
              }
            end
          end
        end
      end
    end
  end
end
