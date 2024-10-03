module Notifications
  class OnNotificationCommands
    def initialize(event_store)
      @repository = Infra::AggregateRootRepository.new(event_store)
    end

    def call(command)
      @repository.with_aggregate(Notification, command.aggregate_id) do |notification|
        case command
        when CreateNotification
          notification.create(command.user_id, command.content, command.type)
        when SendNotification
          notification.send_notification
        when MarkNotificationAsRead
          notification.mark_as_read
        end
      end
    end
  end
end
