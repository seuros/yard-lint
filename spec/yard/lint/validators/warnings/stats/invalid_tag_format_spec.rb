# frozen_string_literal: true

require 'support/one_line_base_parser_examples'

RSpec.describe Yard::Lint::Validators::Warnings::Stats::InvalidTagFormat do
  it_behaves_like(
    'a OneLineBase parser',
    '[warn]: Invalid tag format for @param in file `lib/test.rb` near line 5',
    {
      name: 'InvalidTagFormat',
      message: 'Invalid tag format for @param',
      location: 'lib/test.rb',
      line: 5
    }
  )

  describe 'specific invalid tag format patterns' do
    let(:parser) { described_class.new }

    it 'parses invalid @return format' do
      input = '[warn]: Invalid tag format for @return in file `lib/user.rb` near line 42'
      result = parser.call(input)

      expect(result.first[:message]).to eq('Invalid tag format for @return')
    end
  end
end
