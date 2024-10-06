module Authentication
  class OnUserCommands
    def initialize(event_store)
      @repository = Infra::AggregateRootRepository.new(event_store)
    end

    def call(command)
      @repository.with_aggregate(User, command.aggregate_id) do |user|
        case command
        when RegisterUser
          user.register(
            command.email,
            command.user_type,
            command.wallet_address,
            command.chain_id
          )
        when LogIn
          user.log_in(
            command.session_token,
            command.timestamp
          )
        else
          raise "Unknown command: #{command.class}"
        end
      end
    end
  end
end
