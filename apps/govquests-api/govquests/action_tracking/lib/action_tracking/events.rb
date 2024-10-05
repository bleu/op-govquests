module ActionTracking
  class ActionCreated < Infra::Event
    attribute :action_id, Infra::Types::UUID
    attribute :action_type, Infra::Types::String
    attribute :action_data, Infra::Types::Hash
  end

  class ActionExecutionStarted < Infra::Event
    attribute :execution_id, Infra::Types::UUID
    attribute :action_id, Infra::Types::UUID
    attribute :user_id, Infra::Types::UUID
    attribute :started_at, Infra::Types::Time
    attribute :data, Infra::Types::Hash
  end

  class ActionExecutionCompleted < Infra::Event
    attribute :execution_id, Infra::Types::UUID
    attribute :data, Infra::Types::Hash
  end
end
