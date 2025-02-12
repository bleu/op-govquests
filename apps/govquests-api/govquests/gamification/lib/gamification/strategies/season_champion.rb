module Gamification
  module Strategies
    class SeasonChampion < Base
      def verify_completion?

        return false unless end_of_season?
        return false if has_champion?

        tier_title = @badge_data[:tier]
        tier_id = TierReadModel.find_by_title(tier_title).tier_id
        user = Gamification::GameProfileReadModel.find_by(user_id: @user_id)

        return false unless user.tier_id == tier_id
        return false unless user.rank == 1

        true
      end

      private 

      def end_of_season?
        end_of_season = @badge_data[:end_date].to_date

        end_of_season.past? or end_of_season.today
      end

      def has_champion?
        # Check if there is a champion for the season
        # If there is, return true
        # If there isn't, return false
        special_badge = Gamification::SpecialBadge.new(@badge_id)

        special_badge.unlocked_by.any?
      end

    end
  end
end