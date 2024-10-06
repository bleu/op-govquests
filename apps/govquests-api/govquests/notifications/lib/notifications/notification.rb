module Notifications
  class Notification
    include AggregateRoot

    def initialize(id)
      @id = id
      @user_id = nil
      @content = nil
      @type = nil
      @sent_at = nil
      @read_at = nil
    end

    def create(user_id, content, type)
      apply NotificationCreated.new(data: {
        notification_id: @id,
        user_id: user_id,
        content: content,
        notification_type: type
      })
    end

    def send_notification
      apply NotificationSent.new(data: {
        notification_id: @id,
        sent_at: Time.now
      })
    end

    def mark_as_read
      apply NotificationMarkedAsRead.new(data: {
        notification_id: @id,
        read_at: Time.now
      })
    end

    private

    on NotificationCreated do |event|
      @user_id = event.data[:user_id]
      @content = event.data[:content]
      @type = event.data[:notification_type]
    end

    on NotificationSent do |event|
      @sent_at = event.data[:sent_at]
    end

    on NotificationMarkedAsRead do |event|
      @read_at = event.data[:read_at]
    end
  end
end
