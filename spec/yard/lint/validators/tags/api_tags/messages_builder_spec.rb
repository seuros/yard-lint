# frozen_string_literal: true

RSpec.describe Yard::Lint::Validators::Tags::ApiTags::MessagesBuilder do
  describe '.call' do
    it 'builds message for missing API tag' do
      offense = {
        object_name: 'MyClass#method',
        status: 'missing'
      }

      message = described_class.call(offense)

      expect(message).to eq('Public object `MyClass#method` is missing @api tag')
    end

    it 'builds message for invalid API tag with api_value' do
      offense = {
        object_name: 'MyClass#method',
        status: 'invalid:internal',
        api_value: 'internal'
      }

      message = described_class.call(offense)

      expect(message).to eq("Object `MyClass#method` has invalid @api tag value: 'internal'")
    end

    it 'builds message for invalid API tag from status' do
      offense = {
        object_name: 'MyClass',
        status: 'invalid:deprecated'
      }

      message = described_class.call(offense)

      expect(message).to eq("Object `MyClass` has invalid @api tag value: 'deprecated'")
    end
  end
end
