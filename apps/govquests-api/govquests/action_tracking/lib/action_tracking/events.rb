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
    attribute :quest_id, Infra::Types::UUID
    attribute :started_at, Infra::Types::Time
    attribute :start_data, Infra::Types::Hash
    attribute :nonce, Infra::Types::String
  end

  class ActionExecutionCompleted < Infra::Event
    attribute :execution_id, Infra::Types::UUID
    attribute :completion_data, Infra::Types::Hash
    attribute :quest_id, Infra::Types::UUID.optional
    attribute :action_id, Infra::Types::UUID.optional
    attribute :user_id, Infra::Types::UUID.optional
  end
end
