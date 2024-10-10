require "infra"

require_relative "processes/start_quest_on_action_execution_started"

module Processes
  class Configuration
    def call(event_store, command_bus)
      StartQuestOnActionExecutionStarted.new(event_store, command_bus).subscribe
    end
  end
end
