module Notifications
  class NotificationTemplateCreated < Infra::Event
    attribute :template_id, Infra::Types::UUID
    attribute :name, Infra::Types::String
    attribute :content, Infra::Types::String
    attribute :template_type, Infra::Types::String
  end

  class NotificationTemplateUpdated < Infra::Event
    attribute :template_id, Infra::Types::UUID
    attribute :name, Infra::Types::String.optional
    attribute :content, Infra::Types::String.optional
    attribute :template_type, Infra::Types::String.optional
  end

  class NotificationTemplateDeleted < Infra::Event
    attribute :template_id, Infra::Types::UUID
  end
end
