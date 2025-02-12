module Gamification
  module Strategies
    class SeasonChampion < Base
      def verify_completion?

        return false unless end_of_season?
        return false if unlocked_by_other?

        tier_title = @badge_data[:tier]
        tier_id = TierReadModel.find_by_title(tier_title).tier_id
        user = Gamification::GameProfileReadModel.find_by(profile_id: @user_id)

        return false unless user.tier_id == tier_id
        return false unless user.rank == 1

        true
      end

      private 

      def end_of_season?
        end_of_season = @badge_data[:end_date].to_date

        end_of_season.past? or end_of_season.today?
        true
      end

      def unlocked_by_other?
        return false unless @unlocked_by.any?

        @unlocked_by.any? do |unlocked_user_id|
          unlocked_user_id != @user_id
        end
      end
    end
  end
end