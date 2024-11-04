module Processes
  class ProposeTokenClaimTransaction
    def initialize(event_store, command_bus)
      @event_store = event_store
      @command_bus = command_bus
    end

    def subscribe
      @event_store.subscribe(self, to: [Gamification::TokenClaimStarted])
    end

    def call(event)
      profile_id = event.data[:profile_id]
      token_address = event.data[:token_address]
      amount = event.data[:amount]
      claim_metadata = event.data[:claim_metadata]

      user = Authentication::UserReadModel.find_by(user_id: profile_id)
      unless user
        return
      end

      to_address = claim_metadata[:user_address]

      proposer = Safe::ProposeErc20Transfer.new(
        to_address: to_address,
        value: amount,
        token_address: token_address
      )

      unless proposer.valid?
        return
      end

      proposer.call
    end
  end
end
