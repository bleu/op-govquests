module Questing
  module Queries
    class AllQuests
      def self.call
        Questing::QuestReadModel.all
      end
    end

    class FindQuest
      def self.call(slug)
        Questing::QuestReadModel.find_by(slug: slug)
      end
    end
  end
end
