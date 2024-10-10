module Questing
  class OnQuestCommands
    def initialize(event_store)
      @repository = Infra::AggregateRootRepository.new(event_store)
    end

    def call(command)
      case command
      when CreateQuest
        handle_create_quest(command)
      when AssociateActionWithQuest
        handle_associate_action_with_quest(command)
      when StartUserQuest
        handle_start_user_quest(command)
      when CompleteUserQuest
        handle_complete_user_quest(command)
      when UpdateUserQuestProgress
        handle_update_user_quest_progress(command)
      else
        raise "Unknown command: #{command.class}"
      end
    end

    private

    def handle_create_quest(command)
      @repository.with_aggregate(Quest, command.aggregate_id) do |quest|
        quest.create(command.display_data, command.quest_type, command.audience, command.rewards)
      end
    end

    def handle_associate_action_with_quest(command)
      @repository.with_aggregate(Quest, command.aggregate_id) do |quest|
        quest.associate_action(command.action_id, command.position)
      end
    end

    def handle_start_user_quest(command)
      quest = @repository.load(Quest.new(command.quest_id), "Quest$#{command.quest_id}")
      actions = quest.actions.map { |action| action[:id] }

      @repository.with_aggregate(UserQuest, command.aggregate_id) do |user_quest|
        user_quest.start(command.quest_id, command.user_id, actions)
      end
    end

    def handle_complete_user_quest(command)
      @repository.with_aggregate(UserQuest, command.aggregate_id) do |user_quest|
        user_quest.complete
      end
    end

    def handle_update_user_quest_progress(command)
      @repository.with_aggregate(UserQuest, command.aggregate_id) do |user_quest|
        user_quest.add_progress(command.action_id, command.data)
      end
    end
  end
end
