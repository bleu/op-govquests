module Questing
  class TrackQuestReadModel < ApplicationRecord
    self.table_name = "track_quests"

    belongs_to :track,
      class_name: "Tracking::TrackReadModel",
      foreign_key: "track_id",
      primary_key: "track_id"

    belongs_to :quest,
      class_name: "Questing::QuestReadModel",
      foreign_key: "quest_id",
      primary_key: "quest_id"

    validates :track_id, presence: true
    validates :quest_id, presence: true
    validates :position, presence: true
    validates :quest_id, uniqueness: {scope: :track_id}
    validates :position, uniqueness: {scope: :track_id}
  end
end

# == Schema Information
#
# Table name: track_quests
#
#  id         :bigint           not null, primary key
#  position   :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  quest_id   :string           not null
#  track_id   :string           not null
#
# Indexes
#
#  index_track_quests_on_track_id_and_position  (track_id,position) UNIQUE
#  index_track_quests_on_track_id_and_quest_id  (track_id,quest_id) UNIQUE
#
