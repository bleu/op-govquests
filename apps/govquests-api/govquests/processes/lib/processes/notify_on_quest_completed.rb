module Processes
  class NotifyOnQuestCompleted
    def initialize(event_store, command_bus)
      @event_store = event_store
      @command_bus = command_bus
    end

    def subscribe
      @event_store.subscribe(self, to: [::Questing::QuestCompleted])
    end

    def call(event)
      user_id = event.data[:user_id]
      quest_id = event.data[:quest_id]

      quest = reconstruct_quest(quest_id)
      return unless quest

      user = reconstruct_user(user_id)
      tier = reconstruct_tier(user&.tier_id)
      multiplier = tier&.multiplier || 1

      @command_bus.call(
        ::Notifications::CreateNotification.new(
          notification_id: SecureRandom.uuid,
          user_id: user_id,
          content: "Earned #{quest.points} points for completing a quest + #{multiplier}x tier bonus! Total #{(quest.points * multiplier).to_i} points!",
          notification_type: "quest_completed",
          cta_text: nil,
          cta_url: nil
        )
      )
    end

    private

    def reconstruct_quest(quest_id)
      stream_name = "Questing::Quest$#{quest_id}"
      events = @event_store.read.stream(stream_name).to_a

      return nil if events.empty?

      quest = OpenStruct.new(display_data: {}, points: nil)

      events.each do |event|
        case event
        when ::Questing::QuestCreated
          quest.display_data = event.data[:display_data]
        when ::Questing::RewardPoolAssociated
          if event.data[:reward_definition][:type] == "Points" 
            quest.points = event.data[:reward_definition][:amount]
          end
        end
      end

      quest
    end

    def reconstruct_user(user_id)
      stream_name = "Gamification::GameProfile$#{user_id}"
      events = @event_store.read.stream(stream_name).to_a

      return nil if events.empty?

      user = OpenStruct.new(tier_id: nil)

      events.each do |event|
        case event
        when ::Gamification::TierAchieved
          user.tier_id = event.data[:tier_id]
        end
      end

      user
    end

    def reconstruct_tier(tier_id)
      stream_name = "Gamification::Tier$#{tier_id}"
      events = @event_store.read.stream(stream_name).to_a

      return nil if events.empty?

      tier = OpenStruct.new(multiplier: nil)

      tier_created_event_name = "Gamification::TierCreated"

      events.each do |event|
        case event
        when tier_created_event_name.constantize
          tier.multiplier = event.data[:multiplier]
        end
      end

      tier
    end
  end
end
