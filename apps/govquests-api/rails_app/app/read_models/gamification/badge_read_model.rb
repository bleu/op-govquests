module Gamification
  class BadgeReadModel < ApplicationRecord
    self.table_name = "badges"

    belongs_to :badgeable, polymorphic: true

    validates :badge_id, presence: true, uniqueness: true
    validates :display_data, presence: true

    has_many :user_badges,
      class_name: "Gamification::UserBadgeReadModel",
      as: :badgeable
  end
end

# == Schema Information
#
# Table name: badges
#
#  id             :bigint           not null, primary key
#  badgeable_type :string           not null
#  display_data   :jsonb            not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  badge_id       :string           not null
#  badgeable_id   :string           not null
#
# Indexes
#
#  index_badges_on_badge_id                         (badge_id) UNIQUE
#  index_badges_on_badgeable_type_and_badgeable_id  (badgeable_type,badgeable_id) UNIQUE
#
