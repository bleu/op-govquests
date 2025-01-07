module Questing
  class Track
    include AggregateRoot

    AlreadyExists = Class.new(StandardError)
    QuestAlreadyAssociated = Class.new(StandardError)

    def initialize(id)
      @id = id
      @quests = []
      @display_data = nil
      @badge_id = nil
    end

    def create(display_data:, quest_ids:, badge_id:, badge_display_data:)
      raise AlreadyExists if @display_data

      apply TrackCreated.new(
        data: {
          track_id: @id,
          display_data: display_data,
          quest_ids: quest_ids,
          badge_id: badge_id,
          badge_display_data: badge_display_data
        }
      )
    end

    on TrackCreated do |event|
      @display_data = event.data[:display_data]
      @quest_ids = event.data[:quest_ids]
      @badge_id = event.data[:badge_id]
      @display_data = event.data[:badge_display_data]
    end
  end
end
