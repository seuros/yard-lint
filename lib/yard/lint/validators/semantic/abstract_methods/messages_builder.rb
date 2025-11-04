# frozen_string_literal: true

module Yard
  module Lint
    module Validators
      # Semantic validators - check code semantics and implementation correctness
      module Semantic
        module AbstractMethods
          # Builds messages for abstract method offenses
          class MessagesBuilder
            # Build message for abstract method offense
            # @param offense [Hash] offense data with :method_name key
            # @return [String] formatted message
            def self.call(offense)
              "Abstract method `#{offense[:method_name]}` has implementation " \
              '(should only raise NotImplementedError or be empty)'
            end
          end
        end
      end
    end
  end
end
