module Tracking
  module Queries
    class AllTracks
      def self.call
        Tracking::TrackReadModel.all
      end
    end

    class FindTrack
      def self.call(track_id)
        Tracking::TrackReadModel.find_by(track_id: track_id)
      end
    end
  end
end
