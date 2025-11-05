# frozen_string_literal: true

RSpec.describe Yard::Lint::Results::Base do
  # Create a concrete test implementation
  let(:test_result_class) do
    Class.new(described_class) do
      self.default_severity = 'warning'
      self.offense_type = 'method'
      self.offense_name = 'TestOffense'

      def build_message(offense)
        "Test issue at #{offense[:location]}"
      end

      # Override to return predictable validator name
      def validator_name
        'Tags/TestValidator'
      end
    end
  end

  let(:parsed_data) do
    [
      { location: '/path/to/file.rb', line: 10, method_name: '#foo' },
      { location: '/path/to/other.rb', line: 20, method_name: '#bar' }
    ]
  end

  let(:config) { nil }
  let(:result) { test_result_class.new(parsed_data, config) }

  describe '#initialize' do
    it 'builds offenses from parsed data' do
      expect(result.offenses).to be_an(Array)
      expect(result.offenses.size).to eq(2)
    end

    it 'stores config' do
      config_double = instance_double(Yard::Lint::Config)
      allow(config_double).to receive(:validator_severity).and_return(nil)
      result_with_config = test_result_class.new(parsed_data, config_double)
      expect(result_with_config.config).not_to be_nil
    end

    it 'handles nil parsed data' do
      result = test_result_class.new(nil, config)
      expect(result.offenses).to eq([])
    end

    it 'handles empty array' do
      result = test_result_class.new([], config)
      expect(result.offenses).to eq([])
    end
  end

  describe '#offenses' do
    it 'returns array of offense hashes' do
      expect(result.offenses).to all(be_a(Hash))
    end

    it 'includes required keys in each offense' do
      offense = result.offenses.first
      expect(offense).to include(
        :severity,
        :type,
        :name,
        :message,
        :location,
        :location_line
      )
    end

    it 'uses default severity when no config' do
      expect(result.offenses.first[:severity]).to eq('warning')
    end

    it 'uses configured offense type' do
      expect(result.offenses.first[:type]).to eq('method')
    end

    it 'uses configured offense name' do
      expect(result.offenses.first[:name]).to eq('TestOffense')
    end

    it 'builds message for each offense' do
      expect(result.offenses.first[:message]).to eq('Test issue at /path/to/file.rb')
    end

    it 'extracts location from parsed data' do
      expect(result.offenses.first[:location]).to eq('/path/to/file.rb')
    end

    it 'extracts line number from parsed data' do
      expect(result.offenses.first[:location_line]).to eq(10)
    end

    it 'defaults line number to 0 if missing' do
      data = [{ location: '/path/to/file.rb' }]
      result = test_result_class.new(data, config)
      expect(result.offenses.first[:location_line]).to eq(0)
    end
  end

  describe '#default_severity' do
    it 'raises NotImplementedError if not overridden' do
      base_class = Class.new(described_class) do
        def build_message(_offense)
          'message'
        end
      end

      expect { base_class.new([{}], nil).offenses }.to raise_error(NotImplementedError)
    end
  end

  describe '#build_message' do
    it 'raises NotImplementedError if not overridden' do
      base_class = Class.new(described_class) do
        self.default_severity = 'warning'
      end

      expect { base_class.new([{}], nil).offenses }.to raise_error(NotImplementedError)
    end
  end

  describe '#offense_type' do
    it 'defaults to "line"' do
      minimal_class = Class.new(described_class) do
        self.default_severity = 'warning'

        def build_message(_offense)
          'message'
        end
      end

      result = minimal_class.new([{}], nil)
      expect(result.offenses.first[:type]).to eq('line')
    end
  end

  describe '#offense_name' do
    it 'extracts from class name by default' do
      named_class = Class.new(described_class) do
        class << self
          def name
            'Yard::Lint::Validators::Tags::MyCustomResult'
          end
        end

        self.default_severity = 'warning'

        def build_message(_offense)
          'message'
        end
      end

      result = named_class.new([{}], nil)
      expect(result.send(:computed_offense_name)).to eq('MyCustom')
    end
  end

  describe '#validator_name' do
    it 'extracts validator name from class path' do
      # This is tested via the actual validator result classes
      # The test_result_class overrides this for predictability
      expect(result.validator_name).to eq('Tags/TestValidator')
    end
  end

  context 'with configuration' do
    let(:config) do
      instance_double(Yard::Lint::Config, validator_severity: 'error')
    end

    it 'uses configured severity' do
      result = test_result_class.new(parsed_data, config)
      expect(result.offenses.first[:severity]).to eq('error')
    end

    it 'falls back to default severity if config returns nil' do
      allow(config).to receive(:validator_severity).and_return(nil)
      result = test_result_class.new(parsed_data, config)
      expect(result.offenses.first[:severity]).to eq('warning')
    end
  end
end
