module ActionTracking
  class OnActionCommands
    def initialize(event_store)
      @repository = Infra::AggregateRootRepository.new(event_store)
    end

    def call(command)
      case command
      when ActionTracking::CreateAction
        handle_create_action(command)
      when ActionTracking::StartActionExecution
        handle_start_action_execution(command)
      when ActionTracking::CompleteActionExecution
        handle_complete_action_execution(command)
      else
        raise UnknownCommandError, "Unknown command: #{command.class}"
      end
    end

    private

    def handle_create_action(command)
      @repository.with_aggregate(Action, command.aggregate_id) do |action|
        action.create(command.action_type, command.action_data)
      end
    end

    def handle_start_action_execution(command)
      @repository.with_aggregate(ActionExecution, command.aggregate_id) do |execution|
        execution.start(command.action_id, command.user_id, command.data)
      end
    end

    def handle_complete_action_execution(command)
      @repository.with_aggregate(ActionExecution, command.aggregate_id) do |execution|
        execution.complete(command.data)
      end
    end
  end

  class UnknownCommandError < StandardError; end
end
