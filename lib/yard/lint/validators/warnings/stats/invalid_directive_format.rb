# frozen_string_literal: true

module Yard
  module Lint
    module Validators
      module Warnings
        module Stats
          # Class used to extract warnings details that are related to invalid directive format
          # @example
          #   [warn]: Invalid directive format for @!macro in file `lib/yard/lint.rb` near line 31
          class InvalidDirectiveFormat < ::Yard::Lint::Parsers::OneLineBase
            # Set of regexps for detecting warnings reported by yard stats
            self.regexps = {
              general: /^\[warn\]: Invalid directive format/,
              message: /\[warn\]: (.*) in file/,
              location: /in file `(.*)`/,
              line: /line (\d*)/
            }.freeze
          end
        end
      end
    end
  end
end
