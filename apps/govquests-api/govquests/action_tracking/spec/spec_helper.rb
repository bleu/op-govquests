require "mutant/minitest/coverage"

require_relative "../lib/action_tracking"
require_relative "../../infra/lib/infra/testing"
require "rspec"

RSpec.configure do |config|
  config.include Infra::TestPlumbing
end
