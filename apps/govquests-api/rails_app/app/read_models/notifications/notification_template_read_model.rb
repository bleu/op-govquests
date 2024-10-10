module Notifications
  class NotificationTemplateReadModel < ApplicationRecord
    self.table_name = "notification_templates"

    validates :template_id, presence: true, uniqueness: true
    validates :name, presence: true, uniqueness: true
    validates :content, presence: true
    validates :template_type, presence: true, inclusion: {in: ["email", "SMS", "push"]}
  end
end
