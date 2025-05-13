module Processes
  class NotifyOnTokenTransferConfirmed
    def initialize(event_store, command_bus)
      @event_store = event_store
      @command_bus = command_bus
    end

    def subscribe
      @event_store.subscribe(self, to: [Rewarding::TokenTransferConfirmed])
    end

    def call(event)
      user_id = event.data[:user_id]

      badge = reconstruct_badge(event.data[:pool_id])
      return unless badge

      @command_bus.call(
        ::Notifications::CreateNotification.new(
          notification_id: SecureRandom.uuid,
          user_id: user_id,
          content: "Your hard work has paid off! You've successfully earned #{event.data[:amount]} OP tokens for completing the <a href='/achievements/#{badge.badge_id}'>#{badge.display_data[:title]}</a> Badge. Check your wallet to see the reward and continue engaging in governance activities.",
          notification_type: "token_transfer_confirmed",
          cta_url: "https://optimistic.etherscan.io/tx/#{event.data[:transaction_hash]}",
          cta_text: "View Transaction"
        )
      )
    end

    private

    def reconstruct_badge(pool_id)
      pool = Rewarding::RewardPoolReadModel.find_by(pool_id: pool_id)
      return nil unless pool

      pool.rewardable
    end
  end
end
