module Gamification
  module Strategies
    class VoterAchievement < Base
      include Import['services.agora']

      def verify_completion?
        required_votes = @badge_data[:required_votes]

        address = Authentication::UserReadModel.find_by(user_id: @user_id).address
        delegate_data = fetch_delegate_data(address)
        number_of_votes = delegate_data.dig("proposalsVotedOn").to_i

        number_of_votes >= required_votes
      end

      private

      def fetch_delegate_data(address)
        agora.get_delegate(address)
      end
    end
  end
end