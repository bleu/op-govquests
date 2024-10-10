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
