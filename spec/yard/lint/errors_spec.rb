# frozen_string_literal: true

RSpec.describe Yard::Lint::Errors do
  describe 'BaseError' do
    it 'is a StandardError' do
      expect(described_class::BaseError.new).to be_a(StandardError)
    end

    it 'accepts a custom message' do
      error = described_class::BaseError.new('custom message')
      expect(error.message).to eq('custom message')
    end
  end

  describe 'ConfigFileNotFoundError' do
    it 'inherits from BaseError' do
      expect(described_class::ConfigFileNotFoundError.new).to be_a(described_class::BaseError)
    end

    it 'can be raised with a message' do
      expect { raise described_class::ConfigFileNotFoundError, 'File not found' }
        .to raise_error(described_class::ConfigFileNotFoundError, 'File not found')
    end
  end

  describe 'CircularDependencyError' do
    it 'inherits from BaseError' do
      expect(described_class::CircularDependencyError.new).to be_a(described_class::BaseError)
    end

    it 'can be raised with a message' do
      expect { raise described_class::CircularDependencyError, 'Circular dependency detected' }
        .to raise_error(described_class::CircularDependencyError, 'Circular dependency detected')
    end
  end
end
