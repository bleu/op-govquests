module Tracking
  class TrackReadModel < ApplicationRecord
    self.table_name = "tracks"

    has_many :track_quests,
      -> { order(position: :asc) },
      class_name: "Tracking::TrackQuestReadModel",
      foreign_key: "track_id",
      primary_key: "track_id"

    has_many :quests,
      through: :track_quests,
      source: :quest

    validates :track_id, presence: true, uniqueness: true
    validates :display_data, presence: true
  end
end

# == Schema Information
#
# Table name: tracks
#
#  id           :bigint           not null, primary key
#  display_data :jsonb            not null
#  quest_ids    :text
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  track_id     :string           not null
#
# Indexes
#
#  index_tracks_on_track_id  (track_id) UNIQUE
#
