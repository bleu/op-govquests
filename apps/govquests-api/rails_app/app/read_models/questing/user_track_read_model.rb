module Questing
  class UserTrackReadModel < ApplicationRecord
    self.table_name = "user_tracks"

    belongs_to :user,
      class_name: "Authentication::UserReadModel",
      foreign_key: "user_id",
      primary_key: "user_id"

    belongs_to :track,
      class_name: "Questing::TrackReadModel",
      foreign_key: "track_id",
      primary_key: "track_id"

    has_many :user_quests,
      class_name: "Questing::UserQuestReadModel",
      primary_key: "user_id",
      foreign_key: "user_id"

    validates :user_id, presence: true
    validates :track_id, presence: true
    validates :completed_at, presence: true, if: :completed?
    validates :user_id, uniqueness: {scope: :track_id}

    def completed?
      status == "completed"
    end
  end
end

# == Schema Information
#
# Table name: user_tracks
#
#  id            :bigint           not null, primary key
#  completed_at  :datetime
#  status        :string           default("in_progress"), not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  track_id      :string           not null
#  user_id       :string           not null
#  user_track_id :string
#
# Indexes
#
#  index_user_tracks_on_status                (status)
#  index_user_tracks_on_track_id              (track_id)
#  index_user_tracks_on_user_id_and_track_id  (user_id,track_id) UNIQUE
#  index_user_tracks_on_user_track_id         (user_track_id) UNIQUE
#
