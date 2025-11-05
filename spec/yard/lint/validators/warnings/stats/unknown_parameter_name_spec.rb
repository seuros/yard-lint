# frozen_string_literal: true

require 'support/one_line_base_parser_examples'

RSpec.describe Yard::Lint::Validators::Warnings::Stats::UnknownParameterName do
  it_behaves_like(
    'a OneLineBase parser',
    '[warn]: @param tag has unknown parameter name: wrong_name for method ' \
    "'Foo#bar' in file `lib/foo.rb` near line 10",
    {
      name: 'UnknownParameterName',
      message: "@param tag has unknown parameter name: wrong_name for method 'Foo#bar'",
      location: 'lib/foo.rb',
      line: 10
    }
  )

  describe 'specific unknown parameter patterns' do
    let(:parser) { described_class.new }

    it 'parses parameter names with underscores' do
      input = '[warn]: @param tag has unknown parameter name: old_param for method ' \
              "'Bar#baz' in file `lib/bar.rb` near line 20"
      result = parser.call(input)

      expect(result.first[:message]).to include('old_param')
      expect(result.first[:message]).to include('Bar#baz')
    end
  end
end
