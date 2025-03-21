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

    def create(display_data:)
      raise AlreadyExists if @display_data

      apply TrackCreated.new(
        data: {
          track_id: @id,
          display_data: display_data,
        }
      )
    end

    def update(display_data:)
      apply TrackUpdated.new(
        data: {
          track_id: @id,
          display_data: display_data,
        }
      )
    end

    def add_quest(quest_id)
      raise QuestAlreadyAssociated if @quests.include?(quest_id)

      apply QuestAddedToTrack.new(data: { track_id: @id, quest_id: quest_id })
    end

    on TrackCreated do |event|
      @display_data = event.data[:display_data]
      @badge_display_data = event.data[:badge_display_data]
    end

    on QuestAddedToTrack do |event|
      @quests << event.data[:quest_id]
    end

    on TrackUpdated do |event|
      @display_data = event.data[:display_data]
    end
  end
end
