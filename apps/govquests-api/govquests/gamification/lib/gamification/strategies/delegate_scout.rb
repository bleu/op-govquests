module Gamification
  module Strategies
    class DelegateScout < Base
      include Infra::Import['services.agora']
      include Shared
      
      DELEGATEE_MAXIMUM_VOTING_POWER = 5000

      def verify_completion?
        address = Authentication::UserReadModel.find_by(user_id: @user_id).address

        delegatees_data = fetch_delegatees_data(address)

        delegatees_data.any? do |delegatee|
          total_delegated_raw = delegatee.dig("allowance").to_i
          delegatee_data = fetch_delegate_data(delegatee.dig("to"))

          verify_delegatee_voting_power(
            amount_delegated: total_delegated_raw,
            delegatee_data: delegatee_data,
            maximum_voting_power: DELEGATEE_MAXIMUM_VOTING_POWER
          ) && verify_delegate_active(delegatee_data)
        end
      end

      private 

      def fetch_delegate_data(address)
        agora.get_delegate(address)
      end

      def fetch_delegatees_data(address)
        agora.get_delegatees(address)
      end
    end
  end
end