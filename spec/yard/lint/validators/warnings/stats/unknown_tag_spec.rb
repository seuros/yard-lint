# frozen_string_literal: true

require 'support/one_line_base_parser_examples'

RSpec.describe Yard::Lint::Validators::Warnings::Stats::UnknownTag do
  it_behaves_like(
    'a OneLineBase parser',
    '[warn]: Unknown tag @example1 in file `/builds/path/engine.rb` near line 32',
    {
      name: 'UnknownTag',
      message: 'Unknown tag @example1',
      location: '/builds/path/engine.rb',
      line: 32
    }
  )

  describe 'specific unknown tag patterns' do
    let(:parser) { described_class.new }

    it 'parses tags with special characters' do
      input = '[warn]: Unknown tag @api_endpoint in file `lib/api.rb` near line 10'
      result = parser.call(input)

      expect(result.first[:message]).to eq('Unknown tag @api_endpoint')
    end

    it 'parses tags with numbers' do
      input = '[warn]: Unknown tag @version2 in file `lib/version.rb` near line 5'
      result = parser.call(input)

      expect(result.first[:message]).to eq('Unknown tag @version2')
    end
  end
end
