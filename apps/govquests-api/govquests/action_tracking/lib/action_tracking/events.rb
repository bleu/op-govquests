module ActionTracking
  class ActionCreated < Infra::Event
    attribute :action_id, Infra::Types::UUID
    attribute :content, Infra::Types::String
    attribute :priority, Infra::Types::String
    attribute :channel, Infra::Types::String
  end

  class ActionExecuted < Infra::Event
    attribute :action_id, Infra::Types::UUID
    attribute :user_id, Infra::Types::UUID
    attribute :timestamp, Infra::Types::Time
  end
end
