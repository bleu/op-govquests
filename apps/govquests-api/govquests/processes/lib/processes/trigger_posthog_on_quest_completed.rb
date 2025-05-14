
module Processes
  class TriggerPosthogOnQuestCompleted
    def initialize(event_store, command_bus)
      @event_store = event_store
      @command_bus = command_bus
    end

    def subscribe
      @event_store.subscribe(self, to: [::Questing::QuestCompleted])
    end

    def call(event)
      badge_id = Gamification.generate_badge_id("Quest", event.data[:quest_id])
      badge = reconstruct_badge(badge_id)

      quest = reconstruct_quest(event.data[:quest_id])

      PosthogTrackingService.track_event("quest_completed", {
        quest_id: event.data[:quest_id],
        user_id: event.data[:user_id],
        quest_completion_time: Time.now.iso8601,
        quest_title: quest.title,
        quest_points: quest.points,
        badge_title: badge.title
      }, event.data[:user_id])
    end

    private

    def reconstruct_quest(quest_id)
      stream_name = "Questing::Quest$#{quest_id}"
      events = @event_store.read.stream(stream_name).to_a

      return nil if events.empty?

      quest = OpenStruct.new(title: nil, points: nil)

      events.each do |event|
        case event
        when ::Questing::QuestCreated
          quest.title = event.data[:display_data].dig("title")
        when ::Questing::RewardPoolAssociated
          if event.data[:reward_definition][:type] == "Points"
            quest.points = event.data[:reward_definition][:amount]
          end
        end
      end

      quest
    end

    def reconstruct_badge(badge_id)
      stream_name = "Gamification::Badge$#{badge_id}"
      events = @event_store.read.stream(stream_name).to_a

      return nil if events.empty?

      badge = OpenStruct.new(title: nil)

      events.each do |event|
        case event
        when ::Gamification::BadgeCreated
          badge.title = event.data[:display_data].dig("title")
        end
      end

      badge
    end
  end
end
