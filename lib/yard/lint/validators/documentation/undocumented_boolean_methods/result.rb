# frozen_string_literal: true

require_relative '../../../results/base'
require_relative '../undocumented_objects/messages_builder'

module Yard
  module Lint
    module Validators
      module Documentation
        module UndocumentedBooleanMethods
          # Result object for undocumented boolean methods validation
          # Reuses UndocumentedObjects::MessagesBuilder
          class Result < Results::Base
            self.default_severity = 'warning'
            self.offense_type = 'line'
            self.offense_name = 'UndocumentedObject'

            # Build human-readable message for undocumented boolean method offense
            # @param offense [Hash] offense data
            # @return [String] formatted message
            def build_message(offense)
              UndocumentedObjects::MessagesBuilder.call(offense)
            end
          end
        end
      end
    end
  end
end
