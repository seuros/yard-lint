# frozen_string_literal: true

RSpec.describe Yard::Lint::Validators::Tags::InvalidTypes::MessagesBuilder do
  describe '.call' do
    it 'builds message for invalid tag types' do
      offense = { method_name: 'calculate' }

      message = described_class.call(offense)

      expect(message).to eq('The `calculate` has at least one tag with an invalid type definition.')
    end

    it 'builds message for class method' do
      offense = { method_name: 'MyClass.validate' }

      message = described_class.call(offense)

      expect(message).to eq('The `MyClass.validate` has at least one tag with an invalid type definition.')
    end
  end
end
