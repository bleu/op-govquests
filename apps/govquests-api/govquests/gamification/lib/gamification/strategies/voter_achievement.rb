module Gamification
  module Strategies
    class VoterAchievement < Base
      def verify_completion?
        required_votes = @badge_data[:required_votes]

        address = Authentication::UserReadModel.find_by(user_id: @user_id).address
        delegate_data = fetch_delegate_data(address)
        number_of_votes = delegate_data.dig("proposalsVotedOn").to_i

        number_of_votes >= required_votes
      end

      private

      def fetch_delegate_data(address)
        agora_api.get_delegate(address)
      end

      def agora_api
        @agora_api ||= AgoraApi::Client.new
      end
    end
  end
end