module ActionTracking
  class CreateAction < Infra::Command
    attribute :action_id, Infra::Types::UUID
    attribute :content, Infra::Types::String
    attribute :priority, Infra::Types::String
    attribute :channel, Infra::Types::String

    alias_method :aggregate_id, :action_id
  end

  class ExecuteAction < Infra::Command
    attribute :action_id, Infra::Types::UUID
    attribute :user_id, Infra::Types::UUID
    attribute :timestamp, Infra::Types::Time

    alias_method :aggregate_id, :action_id
  end
end
