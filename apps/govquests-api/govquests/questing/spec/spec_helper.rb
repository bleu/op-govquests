require "mutant/minitest/coverage"

require_relative "../lib/questing"
require "rspec"

RSpec.configure do |config|
  config.include Infra::TestPlumbing
end