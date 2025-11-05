# frozen_string_literal: true

RSpec.describe(
  Yard::Lint::Validators::Documentation::UndocumentedMethodArguments::MessagesBuilder
) do
  describe '.call' do
    it 'builds message for undocumented method arguments' do
      offense = { method_name: 'calculate' }

      message = described_class.call(offense)

      expect(message).to eq(
        'The `calculate` method is missing documentation for some of the arguments.'
      )
    end

    it 'builds message for instance method' do
      offense = { method_name: 'MyClass#process' }

      message = described_class.call(offense)

      expect(message).to eq(
        'The `MyClass#process` method is missing documentation for some of the arguments.'
      )
    end
  end
end
