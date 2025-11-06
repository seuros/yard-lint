# frozen_string_literal: true

RSpec.describe Yard::Lint::Validators::Warnings::Stats::UnknownParameterName do
  let(:parser) { described_class.new }

  describe '#call' do
    context 'with valid two-line input' do
      it 'parses warning data correctly' do
        input = "[warn]: @param tag has unknown parameter name: wrong_name \n" \
                '    in file `/home/user/lib/foo.rb\' near line 10'
        result = parser.call(input)

        expect(result.size).to eq(1)
        offense = result.first

        expect(offense).to include(
          name: 'UnknownParameterName',
          message: '@param tag has unknown parameter name: wrong_name ',
          location: '/home/user/lib/foo.rb',
          line: 10
        )
      end
    end

    context 'with multiple warnings' do
      it 'parses all warnings' do
        input = "[warn]: @param tag has unknown parameter name: param1 \n" \
                '    in file `lib/foo.rb\' near line 10' + "\n" \
                "[warn]: @param tag has unknown parameter name: param2 \n" \
                '    in file `lib/bar.rb\' near line 20'
        result = parser.call(input)

        expect(result.size).to eq(2)
        expect(result[0][:line]).to eq(10)
        expect(result[1][:line]).to eq(20)
      end
    end

    context 'with parameter names with underscores' do
      it 'parses parameter names correctly' do
        input = "[warn]: @param tag has unknown parameter name: old_param " \
                "for method 'Bar#baz' \n" \
                '    in file `lib/bar.rb\' near line 20'
        result = parser.call(input)

        expect(result.first[:message]).to include('old_param')
        expect(result.first[:message]).to include('Bar#baz')
      end
    end

    context 'with invalid input' do
      it 'returns empty array for non-matching input' do
        input = 'Some random text'
        result = parser.call(input)

        expect(result).to eq([])
      end
    end
  end
end
