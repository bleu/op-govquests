module Authentication
  class RegisterAccountHandler
    def initialize(event_store)
      @repository = Infra::AggregateRootRepository.new(event_store)
    end

    def call(command)
      @repository.with_aggregate(Account, command.aggregate_id) do |account|
        account.register(command.address, command.chain_id)
      end
    end
  end
end
