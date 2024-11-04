module Notifications
  class NotificationReadModel < ApplicationRecord
    self.table_name = "notifications"

    validates :notification_id, presence: true, uniqueness: true
    validates :template_id, presence: true
    validates :user_id, presence: true
    validates :channel, presence: true
    validates :priority, presence: true, numericality: {only_integer: true, greater_than: 0, less_than: 6}
    validates :status, presence: true, inclusion: {in: %w[created scheduled sent received opened]}
  end
end

# == Schema Information
#
# Table name: notifications
#
#  id                :bigint           not null, primary key
#  channel           :string           not null
#  content           :string           not null
#  notification_type :string           not null
#  opened_at         :datetime
#  priority          :integer          not null
#  received_at       :datetime
#  scheduled_time    :datetime
#  sent_at           :datetime
#  status            :string           default("created")
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  notification_id   :string           not null
#  template_id       :string           not null
#  user_id           :string           not null
#
# Indexes
#
#  index_notifications_on_channel          (channel)
#  index_notifications_on_notification_id  (notification_id) UNIQUE
#  index_notifications_on_template_id      (template_id)
#  index_notifications_on_user_id          (user_id)
#
