module Questing
  class RegisterQuestHandler
    def initialize(event_store)
      @repository = Infra::AggregateRootRepository.new(event_store)
    end

    def call(command)
      @repository.with_aggregate(Quest, command.aggregate_id) do |quest|
        quest.register
      end
    end
  end
end
