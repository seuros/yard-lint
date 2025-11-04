# frozen_string_literal: true

RSpec.describe Yard::Lint::Validators::Documentation::UndocumentedObjects::MessagesBuilder do
  describe '.call' do
    it 'builds message for undocumented object' do
      offense = { element: 'MyClass' }

      message = described_class.call(offense)

      expect(message).to eq('Documentation required for `MyClass`')
    end

    it 'builds message for undocumented module' do
      offense = { element: 'MyModule::MyClass' }

      message = described_class.call(offense)

      expect(message).to eq('Documentation required for `MyModule::MyClass`')
    end
  end
end
