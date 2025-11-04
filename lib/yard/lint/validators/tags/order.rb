# frozen_string_literal: true

module Yard
  module Lint
    module Validators
      module Tags
        # Order validator module
        module Order
          class << self
            # Unique identifier for this validator
            # @return [Symbol] validator identifier
            def id
              :order
            end

            # Default configuration for this validator
            # @return [Hash] default configuration
            def defaults
              {
                'Enabled' => true,
                'Severity' => 'convention',
                'EnforcedOrder' => %w[
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
                ]
              }
            end
          end
        end
      end
    end
  end
end
