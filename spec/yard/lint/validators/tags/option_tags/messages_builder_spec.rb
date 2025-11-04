# frozen_string_literal: true

RSpec.describe Yard::Lint::Validators::Tags::OptionTags::MessagesBuilder do
  describe '.call' do
    it 'builds message for missing option tags' do
      offense = { method_name: 'initialize' }

      message = described_class.call(offense)

      expect(message).to eq(
        'Method `initialize` has options parameter but no @option tags ' \
        'documenting the available options'
      )
    end

    it 'builds message for instance method' do
      offense = { method_name: 'MyClass#configure' }

      message = described_class.call(offense)

      expect(message).to eq(
        'Method `MyClass#configure` has options parameter but no @option tags ' \
        'documenting the available options'
      )
    end
  end
end
