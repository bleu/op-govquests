module Notifications
  class NotificationReadModel < ApplicationRecord
    self.table_name = "notifications"

    validates :notification_id, presence: true, uniqueness: true
    validates :user_id, presence: true
    validates :content, presence: true
    validates :notification_type, presence: true

    has_many :deliveries,
      class_name: "Notifications::NotificationDeliveryReadModel",
      foreign_key: "notification_id",
      primary_key: "notification_id"

    def title
      case notification_type
      when "quest_completed"
        "Quest Completed!"
      when "tier_achieved"
        "Level Up!"
      when "tier_downgraded"
        "Tier Update"
      when "badge_earned"
        "Badge Earned!"
      when "special_badge_earned"
        "Special Badge Collected!"
      when "badge_unlocked"
        "Badge Ready for You!"
      when "podium_rank_up"
        "You’re in the Top 3!"
      else
        "New Notification"
      end
    end
  end
end

# == Schema Information
#
# Table name: notifications
#
#  id                :bigint           not null, primary key
#  content           :string           not null
#  notification_type :string           not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  notification_id   :string           not null
#  user_id           :string           not null
#
# Indexes
#
#  index_notifications_on_notification_id  (notification_id) UNIQUE
#  index_notifications_on_user_id          (user_id)
#
