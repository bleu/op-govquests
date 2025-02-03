module Questing
  class Track
    include AggregateRoot

    AlreadyExists = Class.new(StandardError)
    QuestAlreadyAssociated = Class.new(StandardError)

    def initialize(id)
      @id = id
      @quests = []
      @display_data = nil
    end

    def create(display_data:, badge_display_data:)
      raise AlreadyExists if @display_data

      apply TrackCreated.new(
        data: {
          track_id: @id,
          display_data: display_data,
          badge_display_data: badge_display_data
        }
      )
    end

    def associate_quest(quest_id, position)
      raise QuestAlreadyAssociated if @quests.include?(quest_id)

      apply QuestAssociatedWithTrack.new(
        data: {
          track_id: @id,
          quest_id: quest_id,
          position: position
        }
      )
    end

    on TrackCreated do |event|
      @display_data = event.data[:display_data]
      @badge_display_data = event.data[:badge_display_data]
    end

    on QuestAssociatedWithTrack do |event|
      @quests << event.data[:quest_id]
    end
  end
end
