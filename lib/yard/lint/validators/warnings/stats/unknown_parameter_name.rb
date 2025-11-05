# frozen_string_literal: true

module Yard
  module Lint
    module Validators
      module Warnings
        module Stats
          # Class used to extract warnings details that are related to yard unknown
          # parameter names
          # @example
          #   [warn]: @param tag has unknown parameter name: bad_param
          #   in file `lib/yard/lint.rb` near line 31
          class UnknownParameterName < ::Yard::Lint::Parsers::TwoLineBase
            # Set of regexps for detecting warnings reported by yard stats
            self.regexps = {
              general: /^\[warn\]: @param tag has unknown parameter name/,
              message: /\[warn\]: (.*)$/,
              location: /in file `(.*?)'?\s*near/,
              line: /near line (\d+)/
            }.freeze
          end
        end
      end
    end
  end
end
