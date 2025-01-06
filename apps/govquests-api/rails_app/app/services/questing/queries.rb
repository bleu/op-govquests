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

    class AllTracks
      def self.call
        Questing::TrackReadModel.all
      end
    end

    class FindTrack
      def self.call(track_id)
        Questing::TrackReadModel.find_by(track_id: track_id)
      end
    end
  end
end
