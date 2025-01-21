module Gamification
  module Strategies
    class QuestsCompleted < Base
      def verify_completion?
        quest_titles = @badge_data[:quests]
        quests = Questing::QuestReadModel.where("display_data->>'title' IN (?)", quest_titles)

        quests.all? do |quest|
          quest.user_quests.where(user_id: @user_id).exists?
        end
      end
    end
  end
end