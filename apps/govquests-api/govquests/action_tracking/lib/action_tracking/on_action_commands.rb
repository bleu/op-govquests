module ActionTracking
  class OnActionCommands
    def initialize(event_store)
      @repository = Infra::AggregateRootRepository.new(event_store)
    end

    def call(command)
      @repository.with_aggregate(Action, command.aggregate_id) do |action|
        case command
        when CreateAction
          action.create(command.content, command.priority, command.channel)
        when ExecuteAction
          action.execute(command.user_id, command.timestamp)
        end
      end
    end
  end
end
