require "rspec"
require "mutant/minitest/coverage"

require_relative "../lib/processes"

RSpec.configure do |config|
  config.include Infra::TestPlumbing
end
