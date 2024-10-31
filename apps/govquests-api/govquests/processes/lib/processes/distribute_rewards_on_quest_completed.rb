module Processes
  class DistributeRewardsOnQuestCompleted
    def initialize(event_store, command_bus)
      @event_store = event_store
      @command_bus = command_bus
    end

    def subscribe
      @event_store.subscribe(self, to: [::Questing::QuestCompleted])
    end

    def call(event)
      quest_id = event.data[:quest_id]
      user_id = event.data[:user_id]

      quest = reconstruct_quest(quest_id)
      return unless quest&.reward_pools&.any?

      quest.reward_pools.each do |pool_id|
        command = ::Rewarding::IssueReward.new(
          pool_id: pool_id,
          user_id: user_id
        )

        @command_bus.call(command)
      end
    end

    private

    def reconstruct_quest(quest_id)
      stream_name = "Questing::Quest$#{quest_id}"
      events = @event_store.read.stream(stream_name).to_a

      return nil if events.empty?

      quest = OpenStruct.new(reward_pools: [])

      events.each do |event|
        case event
        when ::Questing::RewardPoolAssociated
          quest.reward_pools << event.data[:pool_id]
        end
      end

      quest
    end
  end
end
