module ActionTracking
  class OnActionCommands
    def initialize(event_store)
      @repository = Infra::AggregateRootRepository.new(event_store)
    end

    def call(command)
      @repository.with_aggregate(Action, command.aggregate_id) do |action|
        case command
        when CreateAction
          action.create(command.content, command.action_type, command.completion_criteria)
        when CompleteAction
          action.complete(command.user_id, command.completion_data)
        else
          raise "Unknown command: #{command.class}"
        end
      end
    end
  end
end
