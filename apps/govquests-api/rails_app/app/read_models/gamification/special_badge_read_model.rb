module Gamification
  class SpecialBadgeReadModel < ApplicationRecord
    self.table_name = "special_badges"

    validates :badge_id, presence: true, uniqueness: true
    validates :display_data, presence: true
    validates :badge_type, presence: true
    validates :badge_data, presence: true
    validates :points, presence: true, numericality: {only_integer: true, greater_than_or_equal_to: 0}

    has_many :user_badges,
      class_name: "Gamification::UserBadgeReadModel",
      as: :badgeable
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
#  points       :integer          not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  badge_id     :string           not null
#
# Indexes
#
#  index_special_badges_on_badge_id  (badge_id) UNIQUE
#
