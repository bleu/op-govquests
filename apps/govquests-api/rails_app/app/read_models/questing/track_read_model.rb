module Questing
  class TrackReadModel < ApplicationRecord
    self.table_name = "tracks"

    attribute :quest_ids, :jsonb, array: true
    attribute :badge_id, :string

    validates :track_id, presence: true, uniqueness: true
    validates :display_data, presence: true
    validates :badge_id, presence: true, allow_nil: true

    def quests
      QuestReadModel.where(quest_id: quest_ids)
    end

    belongs_to :badge,
      class_name: "Rewarding::BadgeReadModel",
      foreign_key: "badge_id",
      primary_key: "badge_id",
      optional: true
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
#  badge_id     :string
#  track_id     :string           not null
#
# Indexes
#
#  index_tracks_on_badge_id  (badge_id)
#  index_tracks_on_track_id  (track_id) UNIQUE
#
