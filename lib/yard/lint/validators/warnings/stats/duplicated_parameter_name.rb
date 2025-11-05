# frozen_string_literal: true

module Yard
  module Lint
    module Validators
      # Warnings validators - catch YARD parser errors and warnings
      module Warnings
        module Stats
          # Class used to extract warnings details that are related to duplicated
          # parameter names
          # @example
          #   [warn]: @param tag has duplicate parameter name: bad_param
          #   in file `lib/yard/lint.rb` near line 31
          class DuplicatedParameterName < ::Yard::Lint::Parsers::OneLineBase
            # Set of regexps for detecting warnings reported by yard stats
            self.regexps = {
              general: /^\[warn\]: @param tag has duplicate parameter name/,
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
