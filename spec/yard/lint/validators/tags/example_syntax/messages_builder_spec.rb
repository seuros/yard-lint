# frozen_string_literal: true

RSpec.describe Yard::Lint::Validators::Tags::ExampleSyntax::MessagesBuilder do
  describe '.call' do
    it 'builds message for syntax error in example' do
      offense = {
        object_name: 'MyClass#method',
        example_name: 'Basic usage',
        error_message: 'syntax error, unexpected end-of-input'
      }

      message = described_class.call(offense)

      expect(message).to eq(
        "Object `MyClass#method` has syntax error in @example 'Basic usage': " \
        'syntax error, unexpected end-of-input'
      )
    end

    it 'builds message with numbered example name' do
      offense = {
        object_name: 'Calculator#add',
        example_name: 'Example 2',
        error_message: 'syntax error, unexpected tIDENTIFIER'
      }

      message = described_class.call(offense)

      expect(message).to eq(
        "Object `Calculator#add` has syntax error in @example 'Example 2': " \
        'syntax error, unexpected tIDENTIFIER'
      )
    end
  end
end
