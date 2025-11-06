# frozen_string_literal: true

require 'support/one_line_base_parser_examples'

RSpec.describe Yard::Lint::Validators::Warnings::Stats::InvalidDirectiveFormat do
  it_behaves_like(
    'a OneLineBase parser',
    '[warn]: Invalid directive format for @!macro in file `lib/macros.rb` near line 8',
    {
      name: 'InvalidDirectiveFormat',
      message: 'Invalid directive format for @!macro',
      location: 'lib/macros.rb',
      line: 8
    }
  )

  describe 'specific invalid directive format patterns' do
    let(:parser) { described_class.new }

    it 'parses invalid @!attribute format' do
      input = '[warn]: Invalid directive format for @!attribute ' \
              'in file `lib/model.rb` near line 12'
      result = parser.call(input)

      expect(result.first[:message]).to eq('Invalid directive format for @!attribute')
    end
  end
end
