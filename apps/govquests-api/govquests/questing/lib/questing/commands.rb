require_relative "../../../shared_kernel/lib/shared_kernel/types/reward_definition"

module Questing
  class CreateQuest < Infra::Command
    attribute :quest_id, Infra::Types::UUID
    attribute :display_data, Infra::Types::Hash
    attribute :audience, Infra::Types::String
    attribute :badge_display_data, Infra::Types::Hash

    alias_method :aggregate_id, :quest_id
  end

  class AssociateRewardPool < Infra::Command
    attribute :quest_id, Infra::Types::UUID
    attribute :pool_id, Infra::Types::UUID
    attribute :reward_definition, SharedKernel::Types::RewardDefinition

    alias_method :aggregate_id, :quest_id
  end

  class AssociateActionWithQuest < Infra::Command
    attribute :quest_id, Infra::Types::UUID
    attribute :action_id, Infra::Types::UUID
    attribute :position, Infra::Types::Integer

    alias_method :aggregate_id, :quest_id
  end

  class StartUserQuest < Infra::Command
    attribute :user_quest_id, Infra::Types::UUID
    attribute :quest_id, Infra::Types::UUID
    attribute :user_id, Infra::Types::UUID

    alias_method :aggregate_id, :user_quest_id
  end

  class CompleteUserQuest < Infra::Command
    attribute :user_quest_id, Infra::Types::UUID

    alias_method :aggregate_id, :user_quest_id
  end

  class UpdateUserQuestProgress < Infra::Command
    attribute :user_quest_id, Infra::Types::UUID
    attribute :action_id, Infra::Types::UUID
    attribute :data, Infra::Types::Hash

    alias_method :aggregate_id, :user_quest_id
  end

  # Track related commands
  class CreateTrack < Infra::Command
    attribute :track_id, Infra::Types::UUID
    attribute :display_data, Infra::Types::Hash
    attribute :quest_ids, Infra::Types::Array
    attribute :badge_display_data, Infra::Types::Hash

    alias_method :aggregate_id, :track_id
  end

  class StartUserTrack < Infra::Command
    attribute :user_track_id, Infra::Types::UUID
    attribute :track_id, Infra::Types::UUID
    attribute :user_id, Infra::Types::UUID

    alias_method :aggregate_id, :user_track_id
  end

  class UpdateUserTrackProgress < Infra::Command
    attribute :user_track_id, Infra::Types::UUID
    attribute :quest_id, Infra::Types::UUID

    alias_method :aggregate_id, :user_track_id
  end


  class CompleteUserTrack < Infra::Command
    attribute :user_track_id, Infra::Types::UUID

    alias_method :aggregate_id, :user_track_id
  end
end
