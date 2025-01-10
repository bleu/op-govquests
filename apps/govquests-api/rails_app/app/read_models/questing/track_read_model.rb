module Questing
  class TrackReadModel < ApplicationRecord
    self.table_name = "tracks"

    attribute :quest_ids, :jsonb, array: true

    validates :track_id, presence: true, uniqueness: true
    validates :display_data, presence: true

    def quests
      QuestReadModel.where(quest_id: quest_ids)
    end
  end
end
