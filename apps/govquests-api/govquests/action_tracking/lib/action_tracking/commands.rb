# govquests/action_tracking/lib/action_tracking/commands.rb
module ActionTracking
  class CreateAction < Infra::Command
    attribute :action_id, Infra::Types::UUID
    attribute :action_type, Infra::Types::String
    attribute :action_data, Infra::Types::Hash
    attribute :display_data, Infra::Types::Hash

    alias_method :aggregate_id, :action_id
  end

  class StartActionExecution < Infra::Command
    attribute :execution_id, Infra::Types::UUID
    attribute :action_id, Infra::Types::UUID
    attribute :user_id, Infra::Types::UUID
    attribute :data, Infra::Types::Hash

    alias_method :aggregate_id, :execution_id
  end

  class CompleteActionExecution < Infra::Command
    attribute :execution_id, Infra::Types::UUID
    attribute :data, Infra::Types::Hash

    alias_method :aggregate_id, :execution_id
  end
end
