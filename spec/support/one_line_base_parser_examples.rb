# frozen_string_literal: true

# Shared examples for OneLineBase parser specs
# All Stats parsers inherit from OneLineBase and follow the same pattern
RSpec.shared_examples 'a OneLineBase parser' do |example_input, expected_output|
  let(:parser) { described_class.new }

  describe '#call' do
    context 'with valid input' do
      it 'parses warning data correctly' do
        result = parser.call(example_input)

        expect(result).to be_an(Array)
        expect(result.size).to eq(1)

        offense = result.first
        expect(offense).to include(
          name: expected_output[:name],
          message: expected_output[:message],
          location: expected_output[:location],
          line: expected_output[:line]
        )
      end
    end

    context 'with multiple warnings' do
      let(:multiple_input) { "#{example_input}\n#{example_input}" }

      it 'parses all warnings' do
        result = parser.call(multiple_input)

        expect(result).to be_an(Array)
        expect(result.size).to eq(2)
        expect(result).to all(include(:name, :message, :location, :line))
      end
    end

    context 'with empty input' do
      it 'returns empty array' do
        result = parser.call('')

        expect(result).to eq([])
      end
    end

    context 'with non-matching input' do
      it 'returns empty array' do
        result = parser.call('This is not a yard warning')

        expect(result).to eq([])
      end
    end

    context 'with mixed input (matching and non-matching lines)' do
      let(:mixed_input) { "Some other text\n#{example_input}\nMore text" }

      it 'only parses matching lines' do
        result = parser.call(mixed_input)

        expect(result.size).to eq(1)
      end
    end
  end

  describe '.regexps' do
    it 'defines all required regexps' do
      expect(described_class.regexps).to include(
        :general,
        :message,
        :location,
        :line
      )
    end

    it 'has frozen regexps hash' do
      expect(described_class.regexps).to be_frozen
    end
  end
end
