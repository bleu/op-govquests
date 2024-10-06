module ActionTracking
  class ActionCreated < Infra::Event
    attribute :action_id, Infra::Types::UUID
    attribute :action_type, Infra::Types::String
    attribute :action_data, Infra::Types::Hash
    attribute :display_data, Infra::Types::Hash
  end

  class ActionExecutionStarted < Infra::Event
    attribute :execution_id, Infra::Types::UUID
    attribute :action_id, Infra::Types::UUID
    attribute :user_id, Infra::Types::UUID
    attribute :started_at, Infra::Types::Time
    attribute :data, Infra::Types::Hash
    attribute :salt, Infra::Types::String
  end

  class ActionExecutionCompleted < Infra::Event
    attribute :execution_id, Infra::Types::UUID
    attribute :data, Infra::Types::Hash
  end

  class ActionExecutionExpired < Infra::Event
    attribute :execution_id, Infra::Types::UUID
    attribute :expired_at, Infra::Types::Time
  end
end
