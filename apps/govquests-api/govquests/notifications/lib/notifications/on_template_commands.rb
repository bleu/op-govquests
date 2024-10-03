# govquests/notifications/lib/notifications/on_template_commands.rb

module Notifications
  class OnTemplateCommands
    def initialize(event_store)
      @repository = Infra::AggregateRootRepository.new(event_store)
    end

    def call(command)
      @repository.with_aggregate(NotificationTemplate, command.aggregate_id) do |template|
        case command
        when CreateNotificationTemplate
          template.create(command.name, command.content, command.type)
        when UpdateNotificationTemplate
          template.update(name: command.name, content: command.content, type: command.type)
        when DeleteNotificationTemplate
          template.delete
        else
          raise "Unknown command: #{command.class}"
        end
      end
    end
  end
end
