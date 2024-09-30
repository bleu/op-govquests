module Questing
  class Quest
    include AggregateRoot

    AlreadyRegistered = Class.new(StandardError)

    def initialize(id)
      @id = id
    end

    def register
      raise AlreadyRegistered if @registered

      apply QuestCreated.new(data: {quest_id: @id})
    end

    private

    on QuestCreated do |event|
      @registered = true
      @status = :draft
    end
  end
end
