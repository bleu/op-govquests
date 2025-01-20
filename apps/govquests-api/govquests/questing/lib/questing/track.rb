module Questing
  class Track
    include AggregateRoot

    AlreadyExists = Class.new(StandardError)
    QuestAlreadyAssociated = Class.new(StandardError)

    def initialize(id)
      @id = id
      @quests = []
      @display_data = nil
      @completed_by = []
    end

    def create(display_data:, quest_ids:, badge_display_data:)
      raise AlreadyExists if @display_data

      apply TrackCreated.new(
        data: {
          track_id: @id,
          display_data: display_data,
          quest_ids: quest_ids,
          badge_display_data: badge_display_data
        }
      )
    end

    def complete(user_id:)
      apply(TrackCompleted.new(data: {
        user_id:,
        track_id: @id
      }))
    end

    on TrackCreated do |event|
      @display_data = event.data[:display_data]
      @quest_ids = event.data[:quest_ids]
      @badge_display_data = event.data[:badge_display_data]
    end

    on TrackCompleted do |event|
      @completed_by ||= []
      @completed_by << event.data[:user_id]
    end
  end
end
