module Questing
  class TrackReadModel < ApplicationRecord
    self.table_name = "tracks"

    attribute :quest_ids, :jsonb, array: true

    validates :track_id, presence: true, uniqueness: true
    validates :display_data, presence: true

    def quests
      QuestReadModel.where(quest_id: quest_ids)
    end

    has_one :badge,
      class_name: "Gamification::BadgeReadModel",
      as: :badgeable
  end
end

# == Schema Information
#
# Table name: tracks
#
#  id           :bigint           not null, primary key
#  display_data :jsonb            not null
#  quest_ids    :jsonb            is an Array
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  track_id     :string           not null
#
# Indexes
#
#  index_tracks_on_track_id  (track_id) UNIQUE
#
