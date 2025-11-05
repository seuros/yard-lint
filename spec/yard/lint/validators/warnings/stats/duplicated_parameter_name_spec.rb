# frozen_string_literal: true

require 'support/one_line_base_parser_examples'

RSpec.describe Yard::Lint::Validators::Warnings::Stats::DuplicatedParameterName do
  it_behaves_like(
    'a OneLineBase parser',
    '[warn]: @param tag has duplicate parameter name: data for method ' \
    "'Processor#process' in file `lib/processor.rb` near line 25",
    {
      name: 'DuplicatedParameterName',
      message: "@param tag has duplicate parameter name: data for method 'Processor#process'",
      location: 'lib/processor.rb',
      line: 25
    }
  )

  describe 'specific duplicated parameter patterns' do
    let(:parser) { described_class.new }

    it 'parses duplicates with different method contexts' do
      input = '[warn]: @param tag has duplicate parameter name: options for method ' \
              "'Config.load' in file `lib/config.rb` near line 50"
      result = parser.call(input)

      expect(result.first[:message]).to include('options')
      expect(result.first[:message]).to include('Config.load')
      expect(result.first[:line]).to eq(50)
    end
  end
end
