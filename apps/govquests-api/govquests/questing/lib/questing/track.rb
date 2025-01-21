module Questing
  class Track
    include AggregateRoot

    AlreadyExists = Class.new(StandardError)
    QuestAlreadyAssociated = Class.new(StandardError)

    attr_reader :quests

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

    on TrackCreated do |event|
      @display_data = event.data[:display_data]
      @quests = event.data[:quest_ids]
      @badge_display_data = event.data[:badge_display_data]
    end
  end
end
