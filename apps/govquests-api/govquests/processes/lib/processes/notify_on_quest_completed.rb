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

      @command_bus.call(
        ::Notifications::CreateNotification.new(
          notification_id: SecureRandom.uuid,
          user_id: user_id,
          content: "Congratulations! You've completed the quest: #{quest.display_data["title"]}",
          notification_type: "quest_completed"
        )
      )
    end

    private

    def reconstruct_quest(quest_id)
      stream_name = "Questing::Quest$#{quest_id}"
      events = @event_store.read.stream(stream_name).to_a

      return nil if events.empty?

      quest = OpenStruct.new(display_data: {})

      events.each do |event|
        case event
        when ::Questing::QuestCreated
          quest.display_data = event.data[:display_data]
        end
      end

      quest
    end
  end
end
