# frozen_string_literal: true

RSpec.describe Yard::Lint::Validators::Tags::ExampleSyntax::Validator do
  let(:config) { Yard::Lint::Config.new }
  let(:selection) { ['lib/example.rb'] }
  let(:validator) { described_class.new(config, selection) }

  describe '#initialize' do
    it 'inherits from Base validator' do
      expect(validator).to be_a(Yard::Lint::Validators::Base)
    end

    it 'stores config and selection' do
      expect(validator.config).to eq(config)
      expect(validator.selection).to eq(selection)
    end
  end

  describe '#call' do
    it 'returns hash with stdout, stderr, exit_code' do
      result = validator.call
      expect(result).to have_key(:stdout)
      expect(result).to have_key(:stderr)
      expect(result).to have_key(:exit_code)
    end
  end

  describe 'query generation' do
    it 'generates a valid YARD query' do
      query = validator.send(:query)
      expect(query).to be_a(String)
      expect(query).to include('object.has_tag?(:example)')
      expect(query).to include('RubyVM::InstructionSequence.compile')
    end

    it 'includes syntax error handling' do
      query = validator.send(:query)
      expect(query).to include('rescue SyntaxError')
      expect(query).to include('syntax_error')
    end

    it 'includes code cleaning logic' do
      query = validator.send(:query)
      expect(query).to include('#\\s*=>') # Strips output indicators
    end

    it 'includes incomplete snippet detection' do
      query = validator.send(:query)
      expect(query).to include('lines.size == 1')
    end
  end

  describe 'yard_cmd generation' do
    it 'generates a valid yard command' do
      cmd = validator.send(:yard_cmd, '/tmp/yardoc', '/tmp/files.txt')

      expect(cmd[:stdout]).to be_a(String)
      expect(cmd[:stderr]).to be_a(String)
      expect(cmd[:exit_code]).to be_a(Integer)
    end
  end
end
