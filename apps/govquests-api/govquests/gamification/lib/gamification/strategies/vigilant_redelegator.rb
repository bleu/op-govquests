require_relative "shared"

module Gamification
  module Strategies
    class VigilantRedelegator < Base
      include Infra::Import['services.curia_hub']
      include Infra::Import['services.agora']
      include Shared

      def verify_completion?
        address = Authentication::UserReadModel.find_by(user_id: @user_id).address
        delegatees_data = fetch_delegatees_data(address)

        previous_delegatee_address = user_last_delegatee(@user_id)

        delegatees_data.any? do |delegatee|
          # Skip if not a redelegation
          next if delegatee.dig("to") == previous_delegatee

          # Skip if current delegatee is not active
          is_current_delegatee_active = is_delegatee_active?(delegatee.dig("to"))
          next unless is_current_delegatee_active

          # Skip if previous delegatee is active
          is_previous_delegatee_active = is_delegatee_active?(previous_delegatee_address)
          next if is_previous_delegatee_active

          Gamification.command_bus.call(
            Gamification::GameProfileDelegateeUpdated.new(
              user_id: @user_id,
              delegatee_address: delegatee.dig("to")
            )
          )

          true
        end
      end

      private

      def fetch_delegatees_data(address)
        agora.get_delegatees(address)
      end

      def is_delegatee_active?(address)
        curia_hub.fetch_delegate_status(address) == "ACTIVE"
      end

      def user_last_delegatee(user_id)
        stream_name = "Gamification::GameProfile$#{user_id}"
        event_store = Gamification.event_store
        events = event_store.read.stream(stream_name).to_a

        return nil if events.empty?

        delegatee_updated_events = events.find_all { |event| event.is_a?(Gamification::GameProfileDelegateeUpdated) }

        return nil if delegatee_updated_events.empty?

        delegatee_updated_events.last.data[:delegatee_address]
      end
    end
  end
end