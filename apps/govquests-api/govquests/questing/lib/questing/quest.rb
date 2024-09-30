module Questing
  class Quest
    include AggregateRoot

    AlreadyRegistered = Class.new(StandardError)

    def initialize(id)
      @id = id
    end

    def register
      raise AlreadyRegistered if @registered

      apply QuestRegistered.new(data: { quest_id: @id })
    end

    private

    on QuestRegistered do |event|
      @registered = true
    end
  end
end
