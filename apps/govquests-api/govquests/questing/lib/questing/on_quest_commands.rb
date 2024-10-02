# govquests/questing/lib/questing/on_quest_commands.rb
module Questing
  class OnQuestCommands
    def initialize(event_store)
      @repository = Infra::AggregateRootRepository.new(event_store)
    end

    def call(command)
      @repository.with_aggregate(Quest, command.aggregate_id) do |quest|
        case command
        when CreateQuest
          quest.create(
            command.audience,
            command.type,
            command.duration,
            command.difficulty,
            command.requirements,
            command.reward
          )
        when AssociateActionWithQuest
          quest.associate_action(command.action_id)
        when UpdateQuestProgress
          quest.update_progress(command.user_id, command.action_id)
        end
      end
    end
  end
end
