module Gamification
  class SpecialBadgeReadModel < ApplicationRecord
    self.table_name = "special_badges"

    validates :badge_id, presence: true, uniqueness: true
    validates :display_data, presence: true
    validates :badge_type, presence: true
    validates :badge_data, presence: true

    has_many :reward_pools,
      class_name: "Rewarding::RewardPoolReadModel",
      as: :rewardable

    has_many :user_badges,
      class_name: "Gamification::UserBadgeReadModel",
      as: :badge
  end
end

# == Schema Information
#
# Table name: special_badges
#
#  id           :bigint           not null, primary key
#  badge_data   :jsonb            not null
#  badge_type   :string           not null
#  display_data :jsonb            not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  badge_id     :string           not null
#
# Indexes
#
#  index_special_badges_on_badge_id  (badge_id) UNIQUE
#
