require "minitest/autorun"
require "mutant/minitest/coverage"

require_relative "../lib/questing"

module Questing
  class Test < Infra::InMemoryTest
    def before_setup
      super
      Configuration.new.call(event_store, command_bus)
    end

    private

    def fake_login
      "fake_login"
    end
  end
end
