module ActionTracking
  class ActionCreated < Infra::Event
    attribute :action_id, Infra::Types::UUID
    attribute :content, Infra::Types::String
    attribute :action_type, Infra::Types::String
    attribute :completion_criteria, Infra::Types::Hash
  end

  class ActionExecuted < Infra::Event
    attribute :action_id, Infra::Types::UUID
    attribute :user_id, Infra::Types::UUID
    attribute :completion_data, Infra::Types::Hash
  end
end
