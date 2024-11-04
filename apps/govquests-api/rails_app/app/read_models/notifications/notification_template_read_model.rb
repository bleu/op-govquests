module Notifications
  class NotificationTemplateReadModel < ApplicationRecord
    self.table_name = "notification_templates"

    validates :template_id, presence: true, uniqueness: true
    validates :name, presence: true, uniqueness: true
    validates :content, presence: true
    validates :template_type, presence: true, inclusion: {in: ["email", "SMS", "push"]}
  end
end

# == Schema Information
#
# Table name: notification_templates
#
#  id            :bigint           not null, primary key
#  content       :text             not null
#  name          :string           not null
#  template_type :string           not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  template_id   :string           not null
#
# Indexes
#
#  index_notification_templates_on_name         (name) UNIQUE
#  index_notification_templates_on_template_id  (template_id) UNIQUE
#
