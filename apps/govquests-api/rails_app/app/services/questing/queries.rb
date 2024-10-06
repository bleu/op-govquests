module Questing
  module Queries
    class AllQuests
      def self.call
        Questing::QuestReadModel.all
      end
    end

    class FindQuest
      def self.call(quest_id)
        Questing::QuestReadModel.find_by(quest_id: quest_id)
      end
    end
  end
end
