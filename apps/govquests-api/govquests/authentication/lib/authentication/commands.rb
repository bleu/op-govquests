module Authentication
  class RegisterUser < Infra::Command
    attribute :user_id, Infra::Types::UUID
    attribute :address, Infra::Types::String
    attribute :chain_id, Infra::Types::Integer
    attribute :email, Infra::Types::String.optional
    attribute :user_type, Infra::Types::String

    alias_method :aggregate_id, :user_id
  end

  class UpdateQuestProgress < Infra::Command
    attribute :user_id, Infra::Types::UUID
    attribute :quest_id, Infra::Types::UUID
    attribute :progress_measure, Infra::Types::Integer

    alias_method :aggregate_id, :user_id
  end

  class ClaimReward < Infra::Command
    attribute :user_id, Infra::Types::UUID
    attribute :reward_id, Infra::Types::UUID

    alias_method :aggregate_id, :user_id
  end

  class LogUserActivity < Infra::Command
    attribute :user_id, Infra::Types::UUID
    attribute :action_type, Infra::Types::String
    attribute :action_timestamp, Infra::Types::Time

    alias_method :aggregate_id, :user_id
  end
end
