module Notifications
  class CreateNotificationTemplate < Infra::Command
    attribute :template_id, Infra::Types::UUID
    attribute :name, Infra::Types::String
    attribute :content, Infra::Types::String
    attribute :template_type, Infra::Types::String

    alias_method :aggregate_id, :template_id
  end

  class UpdateNotificationTemplate < Infra::Command
    attribute :template_id, Infra::Types::UUID
    attribute :name, Infra::Types::String.optional
    attribute :content, Infra::Types::String.optional
    attribute :template_type, Infra::Types::String.optional

    alias_method :aggregate_id, :template_id
  end

  class DeleteNotificationTemplate < Infra::Command
    attribute :template_id, Infra::Types::UUID

    alias_method :aggregate_id, :template_id
  end
end
