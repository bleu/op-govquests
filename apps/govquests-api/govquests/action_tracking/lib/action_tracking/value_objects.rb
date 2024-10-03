# govquests/action_tracking/lib/action_tracking/value_objects.rb
module ActionTracking
  class ActionPriority < Dry::Struct
    attribute :priority, Infra::Types::String.enum("Low", "Medium", "High")
  end

  class ActionChannel < Dry::Struct
    attribute :channel, Infra::Types::String.enum("Email", "SMS", "Push")
  end
end
