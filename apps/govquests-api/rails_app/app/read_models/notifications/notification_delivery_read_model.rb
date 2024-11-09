module Notifications
  class NotificationDeliveryReadModel < ApplicationRecord
    self.table_name = "notification_deliveries"

    belongs_to :notification,
      class_name: "Notifications::NotificationReadModel",
      foreign_key: "notification_id",
      primary_key: "notification_id"

    validates :notification_id, presence: true
    validates :delivery_method, presence: true
    validates :status, presence: true, inclusion: {in: %w[pending delivered failed]}

    scope :pending, -> { where(status: "pending") }
    scope :delivered, -> { where(status: "delivered") }
    scope :failed, -> { where(status: "failed") }
    scope :unread, -> { where(read_at: nil) }

    attribute :read_at, :datetime
  end
end

# == Schema Information
#
# Table name: notification_deliveries
#
#  id              :bigint           not null, primary key
#  delivered_at    :datetime
#  delivery_method :string           not null
#  metadata        :jsonb
#  read_at         :datetime
#  status          :string           default("pending"), not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  notification_id :string           not null
#
# Indexes
#
#  idx_on_notification_id_delivery_method_fcac4b8c69  (notification_id,delivery_method) UNIQUE
#  index_notification_deliveries_on_notification_id   (notification_id)
#
