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

  class NotificationTemplateReadModel < ApplicationRecord
    self.table_name = "notification_templates"

    validates :template_id, presence: true, uniqueness: true
    validates :name, presence: true, uniqueness: true
    validates :content, presence: true
    validates :template_type, presence: true, inclusion: {in: ["email", "SMS", "push"]}
  end

  class ReadModelConfiguration
    def call(event_store)
      # Notification Events
      event_store.subscribe(OnNotificationCreated, to: [Notifications::NotificationCreated])
      event_store.subscribe(OnNotificationScheduled, to: [Notifications::NotificationScheduled])
      event_store.subscribe(OnNotificationSent, to: [Notifications::NotificationSent])
      event_store.subscribe(OnNotificationReceived, to: [Notifications::NotificationReceived])
      event_store.subscribe(OnNotificationOpened, to: [Notifications::NotificationOpened])

      # NotificationTemplate Events
      event_store.subscribe(OnTemplateCreated, to: [Notifications::NotificationTemplateCreated])
      event_store.subscribe(OnTemplateUpdated, to: [Notifications::NotificationTemplateUpdated])
      event_store.subscribe(OnTemplateDeleted, to: [Notifications::NotificationTemplateDeleted])
    end
  end
end
