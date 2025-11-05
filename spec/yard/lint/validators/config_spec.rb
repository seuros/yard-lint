# frozen_string_literal: true

RSpec.describe Yard::Lint::Validators::Config do
  describe 'class attributes' do
    let(:test_config_class) do
      Class.new(described_class) do
        self.id = :test_validator
        self.defaults = { 'Enabled' => true, 'Severity' => 'warning' }.freeze
      end
    end

    describe '.id' do
      it 'allows setting and getting validator identifier' do
        expect(test_config_class.id).to eq(:test_validator)
      end

      it 'is accessible as class attribute' do
        expect(test_config_class).to respond_to(:id)
        expect(test_config_class).to respond_to(:id=)
      end
    end

    describe '.defaults' do
      it 'allows setting and getting default configuration' do
        expect(test_config_class.defaults).to eq(
          'Enabled' => true,
          'Severity' => 'warning'
        )
      end

      it 'is accessible as class attribute' do
        expect(test_config_class).to respond_to(:defaults)
        expect(test_config_class).to respond_to(:defaults=)
      end
    end

    describe '.combines_with' do
      it 'returns empty array by default' do
        expect(test_config_class.combines_with).to eq([])
      end

      it 'allows setting validators to combine with' do
        test_config_class.combines_with = ['Other/Validator']
        expect(test_config_class.combines_with).to eq(['Other/Validator'])
      end

      it 'is accessible as class method' do
        expect(test_config_class).to respond_to(:combines_with)
        expect(test_config_class).to respond_to(:combines_with=)
      end

      it 'memoizes empty array on first access' do
        config_class = Class.new(described_class)
        first_call = config_class.combines_with
        second_call = config_class.combines_with
        expect(first_call).to equal(second_call)
      end
    end
  end

  describe 'inheritance' do
    it 'can be subclassed' do
      subclass = Class.new(described_class)
      expect(subclass.superclass).to eq(described_class)
    end

    it 'allows each subclass to have independent configuration' do
      config_a = Class.new(described_class) do
        self.id = :validator_a
        self.defaults = { 'A' => true }.freeze
      end

      config_b = Class.new(described_class) do
        self.id = :validator_b
        self.defaults = { 'B' => false }.freeze
      end

      expect(config_a.id).to eq(:validator_a)
      expect(config_b.id).to eq(:validator_b)
      expect(config_a.defaults).to eq('A' => true)
      expect(config_b.defaults).to eq('B' => false)
    end
  end
end
