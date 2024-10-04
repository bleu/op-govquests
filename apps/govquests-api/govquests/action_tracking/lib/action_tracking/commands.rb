# govquests/action_tracking/lib/action_tracking/commands.rb
module ActionTracking
  class CreateAction < Infra::Command
    attribute :action_id, Infra::Types::UUID
    attribute :content, Infra::Types::String
    attribute :action_type, Infra::Types::String
    attribute :completion_criteria, Infra::Types::Hash

    alias_method :aggregate_id, :action_id
  end

  class CompleteAction < Infra::Command
    attribute :action_id, Infra::Types::UUID
    attribute :user_id, Infra::Types::UUID
    attribute :completion_data, Infra::Types::Hash

    alias_method :aggregate_id, :action_id
  end
end
