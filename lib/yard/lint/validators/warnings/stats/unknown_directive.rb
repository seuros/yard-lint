# frozen_string_literal: true

module Yard
  module Lint
    module Validators
      module Warnings
        module Stats
          # Class used to extract warnings details that are related to yard unknown directives
          # @example
          #   [warn]: Unknown directive @!foo in file `lib/yard/lint.rb` near line 31
          class UnknownDirective < ::Yard::Lint::Parsers::OneLineBase
            # Set of regexps for detecting warnings reported by yard stats
            self.regexps = {
              general: /^\[warn\]: Unknown directive.*@!.*near line/,
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
