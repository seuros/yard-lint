# frozen_string_literal: true

require 'simplecov'
SimpleCov.start do
  add_filter '/spec/'
  add_filter '/vendor/'
end

require 'yard-lint'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  # Only reset cache for tests that explicitly need isolation
  # Use :cache_isolation tag to force cache clearing for specific tests
  config.before(:each, :cache_isolation) do
    Yard::Lint::Validators::Base.reset_command_cache!
    Yard::Lint::Validators::Base.clear_yard_database!
  end

  # Clear cache once before the entire suite to ensure clean start
  config.before(:suite) do
    Yard::Lint::Validators::Base.reset_command_cache!
    Yard::Lint::Validators::Base.clear_yard_database!
  end

  # Clear cache after the entire suite to clean up
  config.after(:suite) do
    Yard::Lint::Validators::Base.clear_yard_database!
  end
end
