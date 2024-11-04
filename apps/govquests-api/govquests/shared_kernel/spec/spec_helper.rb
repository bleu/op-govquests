require "rspec"
require "mutant/minitest/coverage"

require_relative "../lib/shared_kernel"

RSpec.configure do |config|
  config.include Infra::TestPlumbing
end
