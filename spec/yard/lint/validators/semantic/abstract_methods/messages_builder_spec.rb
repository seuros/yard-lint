# frozen_string_literal: true

RSpec.describe Yard::Lint::Validators::Semantic::AbstractMethods::MessagesBuilder do
  describe '.call' do
    it 'builds message for abstract method with implementation' do
      offense = { method_name: 'MyClass#abstract_method' }

      message = described_class.call(offense)

      expect(message).to eq(
        'Abstract method `MyClass#abstract_method` has implementation ' \
        '(should only raise NotImplementedError or be empty)'
      )
    end

    it 'builds message for class method' do
      offense = { method_name: 'MyModule.abstract_factory' }

      message = described_class.call(offense)

      expect(message).to eq(
        'Abstract method `MyModule.abstract_factory` has implementation ' \
        '(should only raise NotImplementedError or be empty)'
      )
    end
  end
end
