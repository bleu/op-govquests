require "spec_helper"
ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?
require "rspec/rails"
require "mutant/minitest/coverage"

# Add additional requires below this line. Rails is not loaded until this point!
ActiveJob::Base.logger = Logger.new(nil)

# Requires supporting ruby files with custom matchers and macros, etc, in
# spec/support/ and its subdirectories.
Dir[Rails.root.join("spec", "support", "**", "*.rb")].sort.each { |f| require f }

require_relative "../../infra/lib/infra/testing"

begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  abort e.to_s.strip
end

RSpec.configure do |config|
  config.include InMemoryRESIntegrationCase

  config.fixture_paths = [
    Rails.root.join("spec/fixtures")
  ]

  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!

  config.before(:suite) do
    Rails.application.load_tasks
    # Uncomment the next line if you want to reset the database before running the test suite
    # Rake::Task["db:reset"].invoke
  end

  config.include InMemoryTestCase, type: :model
  config.include InMemoryRESIntegrationCase
  config.include DomainHelpers

  def run_command(command)
    Rails.configuration.command_bus.call(command)
  end
end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end
