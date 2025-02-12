module Gamification
  module Strategies
    class DelegationEmpowerment < Base
      include Infra::Import['services.agora']

      DELEGATEE_MAXIMUM_VOTING_POWER = 1

      def verify_completion?
        address = Authentication::UserReadModel.find_by(user_id: @user_id).address

        delegatees_data = fetch_delegatees_data(address)

        delegatees_data.any? do |delegatee|
          total_delegated_raw = delegatee.dig("allowance").to_i
          total_delegated = BigDecimal(total_delegated_raw) / BigDecimal("1e18")

          delegatee_data = fetch_delegate_data(delegatee.dig("to"))
          delegatee_voting_power_raw = delegatee_data.dig("votingPower", "total").to_i
          delegatee_voting_power = BigDecimal(delegatee_voting_power_raw) / BigDecimal("1e18")

          delegatee_voting_power - total_delegated <= DELEGATE_MAXIMUM_VOTING_POWER
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