# frozen_string_literal: true

module Yard
  module Lint
    module Validators
      module Documentation
        module UndocumentedObjects
          # Class used to extract details about undocumented objects from raw yard list output
          # @example
          #   /path/to/file.rb:3: UndocumentedClass
          #   /path/to/file.rb:4: UndocumentedClass#method_one
          class Parser < ::Yard::Lint::Parsers::Base
            # Regex used to parse yard list output format: file.rb:LINE: ObjectName
            LINE_REGEX = /^(.+):(\d+): (.+)$/

            # @param yard_list_output [String] raw yard list results string
            # @return [Array<Hash>] Array with undocumented objects details
            def call(yard_list_output)
              yard_list_output
                .split("\n")
                .map(&:strip)
                .reject(&:empty?)
                .filter_map do |line|
                  match = line.match(LINE_REGEX)
                  next unless match

                  {
                    location: match[1],
                    line: match[2].to_i,
                    element: match[3]
                  }
                end
            end
          end
        end
      end
    end
  end
end
