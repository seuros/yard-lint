# frozen_string_literal: true

RSpec.describe Yard::Lint do
  describe 'VERSION' do
    it 'has a version number' do
      expect(Yard::Lint::VERSION).not_to be_nil
      expect(Yard::Lint::VERSION).to match(/\d+\.\d+\.\d+/)
    end
  end

  describe '.run' do
    let(:test_file) { '/tmp/test_lint.rb' }

    before do
      File.write(test_file, <<~RUBY)
        # A simple test class
        class TestClass
          def method_with_params(arg1, arg2)
            arg1 + arg2
          end
        end
      RUBY
    end

    after do
      FileUtils.rm_f(test_file)
    end

    it 'returns a Result object' do
      result = described_class.run(path: test_file)

      expect(result).to be_a(Yard::Lint::Results::Aggregate)
    end

    it 'accepts a config object' do
      config = Yard::Lint::Config.new do |c|
        c.options = ['--private']
      end

      result = described_class.run(path: test_file, config: config)

      expect(result).to be_a(Yard::Lint::Results::Aggregate)
    end

    it 'filters excluded files' do
      config = Yard::Lint::Config.new do |c|
        c.exclude = ['/tmp/**/*']
      end

      result = described_class.run(path: test_file, config: config)

      # Should be clean since file is excluded
      expect(result.clean?).to be true
    end
  end

  # Config loading and path expansion are tested through integration tests
  # that call .run() - no need to test private implementation details directly
end
