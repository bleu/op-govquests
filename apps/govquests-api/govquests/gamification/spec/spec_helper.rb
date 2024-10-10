require "rspec"

require "mutant/minitest/coverage"

require_relative "../lib/gamification"
RSpec.configure do |config|
  config.include Infra::TestPlumbing
end
