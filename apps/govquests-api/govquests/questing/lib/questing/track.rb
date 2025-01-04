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

    def create(display_data:, quest_ids:)
      raise AlreadyExists if @display_data

      apply TrackCreated.new(
        data: {
          track_id: @id,
          display_data: display_data,
          quest_ids: quest_ids
        }
      )
    end

    on TrackCreated do |event|
      @display_data = event.data[:display_data]
      @quest_ids = event.data[:quest_ids]
    end
  end
end
