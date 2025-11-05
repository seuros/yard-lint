# frozen_string_literal: true

require 'support/one_line_base_parser_examples'

RSpec.describe Yard::Lint::Validators::Warnings::Stats::UnknownDirective do
  it_behaves_like(
    'a OneLineBase parser',
    '[warn]: Unknown directive @!foo in file `lib/yard/lint.rb` near line 31',
    {
      name: 'UnknownDirective',
      message: 'Unknown directive @!foo',
      location: 'lib/yard/lint.rb',
      line: 31
    }
  )

  describe 'specific unknown directive patterns' do
    let(:parser) { described_class.new }

    it 'parses directives with underscores' do
      input = '[warn]: Unknown directive @!macro_attach in file `lib/macros.rb` near line 15'
      result = parser.call(input)

      expect(result.first[:message]).to eq('Unknown directive @!macro_attach')
    end
  end
end
