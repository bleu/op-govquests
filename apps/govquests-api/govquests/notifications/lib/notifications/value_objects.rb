module Notifications
  class NotificationStatus < Dry::Struct
    attribute :status, Infra::Types::String

    def self.created
      new(status: "created")
    end

    def self.scheduled
      new(status: "scheduled")
    end

    def self.sent
      new(status: "sent")
    end

    def self.received
      new(status: "received")
    end

    def self.opened
      new(status: "opened")
    end
  end

  class NotificationType < Dry::Struct
    attribute :notification_type, Infra::Types::String
  end

  class NotificationContent < Dry::Struct
    attribute :content, Infra::Types::String

    def initialize(content)
      super
      raise "Content cannot be empty" if content.strip.empty?
    end
  end

  class NotificationChannel < Dry::Struct
    attribute :channel, Infra::Types::String

    VALID_CHANNELS = ["email", "SMS", "push"]

    def initialize(channel)
      super
      raise "Invalid channel" unless VALID_CHANNELS.include?(channel)
    end
  end

  class NotificationPriority < Dry::Struct
    attribute :priority, Infra::Types::Integer.constrained(gt: 0, lt: 6)  # 1 (low) to 5 (high)
  end

  class TemplateName < Dry::Struct
    attribute :name, Infra::Types::String

    def initialize(name)
      super
      raise "Template name cannot be empty" if name.strip.empty?
    end
  end

  class TemplateContent < Dry::Struct
    attribute :content, Infra::Types::String

    def initialize(content)
      super
      raise "Template content cannot be empty" if content.strip.empty?
    end
  end
end
