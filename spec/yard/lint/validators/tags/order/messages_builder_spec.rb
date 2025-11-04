# frozen_string_literal: true

RSpec.describe Yard::Lint::Validators::Tags::Order::MessagesBuilder do
  describe '.call' do
    it 'builds message for invalid tag order' do
      offense = {
        method_name: 'calculate',
        order: 'param,return,raise'
      }

      message = described_class.call(offense)

      expect(message).to eq(
        'The `calculate` has yard tags in an invalid order. ' \
        'Following tags need to be in the presented order: `param`, `return`, `raise`.'
      )
    end

    it 'builds message with single tag' do
      offense = {
        method_name: 'process',
        order: 'param'
      }

      message = described_class.call(offense)

      expect(message).to eq(
        'The `process` has yard tags in an invalid order. ' \
        'Following tags need to be in the presented order: `param`.'
      )
    end
  end
end
