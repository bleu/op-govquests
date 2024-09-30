# lib/questing/on_register_quest.rb
module Questing
  class OnQuestCreated
    def initialize(event_store)
      @repository = Infra::AggregateRootRepository.new(event_store)
    end

    def call(command)
      @repository.with_aggregate(Quest, command.aggregate_id) do |quest|
        quest.create(command.audience, command.type, command.duration, command.difficulty)
      end
    end
  end
end
