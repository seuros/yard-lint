# frozen_string_literal: true

module Yard
  module Lint
    module Validators
      # Tags validators - validate YARD tag quality and consistency
      module Tags
        # ExampleSyntax validator module
        # Validates Ruby syntax in @example tags using RubyVM::InstructionSequence.compile()
        # Automatically strips output indicators (#=>) and skips incomplete single-line snippets
        module ExampleSyntax
        end
      end
    end
  end
end
