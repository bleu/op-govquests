module Rewarding
  class BadgeReadModel < ApplicationRecord
    self.table_name = "badges"

    has_many :tracks,
      class_name: "Tracking::TrackReadModel",
      foreign_key: "badge_id",
      primary_key: "badge_id"

    has_many :quests,
      class_name: "Questing::QuestReadModel",
      foreign_key: "badge_id",
      primary_key: "badge_id"

    validates :badge_id, presence: true, uniqueness: true
    validates :display_data, presence: true
  end
end

# == Schema Information
#
# Table name: badges
#
#  id           :bigint           not null, primary key
#  display_data :jsonb            not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  badge_id     :string           not null
#
# Indexes
#
#  index_badges_on_badge_id  (badge_id) UNIQUE
#
