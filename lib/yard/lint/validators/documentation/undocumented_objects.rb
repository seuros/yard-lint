# frozen_string_literal: true

module Yard
  module Lint
    module Validators
      module Documentation
        # UndocumentedObjects validator module
        # This validator checks for missing documentation on objects
        module UndocumentedObjects
          class << self
            # Unique identifier for this validator
            # @return [Symbol] validator identifier
            def id
              :undocumented_objects
            end

            # Default configuration for this validator
            # @return [Hash] default configuration
            def defaults
              {
                'Enabled' => true,
                'Severity' => 'warning'
              }
            end

            # Validators to combine with this one
            # This is a composite validator that merges results from multiple validators
            # @return [Array<String>] validator names to combine
            def combines_with
              ['Documentation/UndocumentedBooleanMethods']
            end
          end
        end
      end
    end
  end
end
