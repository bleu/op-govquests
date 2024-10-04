module Questing
  class OnQuestCommands
    def initialize(event_store)
      @repository = Infra::AggregateRootRepository.new(event_store)
    end

    def call(command)
      @repository.with_aggregate(Quest, command.aggregate_id) do |quest|
        case command
        when CreateQuest
          quest.create(command.display_data, command.quest_type, command.audience, command.rewards)
        when AssociateActionWithQuest
          quest.associate_action(command.action_id, command.position)
        end
      end
    end
  end
end
