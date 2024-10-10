require "mutant/minitest/coverage"

require_relative "../lib/action_tracking"

require "rspec"

RSpec.configure do |config|
  config.include Infra::TestPlumbing
end
