# frozen_string_literal: true

RSpec.describe Yard::Lint::Validators::Tags::CollectionType::MessagesBuilder do
  describe '.call' do
    context 'when enforcing long style (short detected)' do
      it 'formats message for Hash<K, V> to Hash{K => V}' do
        offense = {
          tag_name: 'param',
          type_string: 'Hash<Symbol, String>',
          detected_style: 'short'
        }

        message = described_class.call(offense)

        expect(message).to include('long collection syntax')
        expect(message).to include('Hash{Symbol => String}')
        expect(message).to include('instead of Hash<Symbol, String>')
        expect(message).to include('@param')
      end

      it 'formats message for {K => V} to Hash{K => V}' do
        offense = {
          tag_name: 'return',
          type_string: '{Symbol => String}',
          detected_style: 'short'
        }

        message = described_class.call(offense)

        expect(message).to include('long collection syntax')
        expect(message).to include('Hash{Symbol => String}')
        expect(message).to include('instead of {Symbol => String}')
        expect(message).to include('@return')
      end

      it 'formats message for nested Hash' do
        offense = {
          tag_name: 'return',
          type_string: 'Hash<String, Hash<Symbol, Integer>>',
          detected_style: 'short'
        }

        message = described_class.call(offense)

        expect(message).to include('long collection syntax')
        expect(message).to include('Hash{String => Hash<Symbol')
        expect(message).to include('@return')
      end
    end

    context 'when enforcing short style (long detected)' do
      it 'formats message for Hash{K => V} to {K => V}' do
        offense = {
          tag_name: 'param',
          type_string: 'Hash{Symbol => String}',
          detected_style: 'long'
        }

        message = described_class.call(offense)

        expect(message).to include('short collection syntax')
        expect(message).to include('{Symbol => String}')
        expect(message).to include('instead of Hash{Symbol => String}')
        expect(message).to include('@param')
      end

      it 'formats message for @option tag' do
        offense = {
          tag_name: 'option',
          type_string: 'Hash{String => Object}',
          detected_style: 'long'
        }

        message = described_class.call(offense)

        expect(message).to include('short collection syntax')
        expect(message).to include('@option')
        expect(message).to include('{String => Object}')
        expect(message).to include('instead of Hash{String => Object}')
      end
    end
  end
end
