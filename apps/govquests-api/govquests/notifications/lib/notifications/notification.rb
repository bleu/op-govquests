require_relative "delivery/base"
module Notifications
  class Notification
    include AggregateRoot

    class AlreadyDeliveredError < StandardError; end

    class DeliveryError < StandardError; end

    def initialize(id)
      @id = id
      @user_id = nil
      @content = nil
      @type = nil
      @delivery_methods = []
      @deliveries = {}
      @cta_text = nil
      @cta_url = nil
      @read_at = nil
    end

    def create(user_id, content, type, cta_text = nil, cta_url = nil, delivery_methods = ["in_app"])
      apply NotificationCreated.new(data: {
        notification_id: @id,
        user_id: user_id,
        content: content,
        cta_text: cta_text,
        cta_url: cta_url,
        notification_type: type,
        delivery_methods: delivery_methods
      })
    end

    def deliver(method)
      raise AlreadyDeliveredError if delivered?(method)

      delivery_strategy = Notifications::Delivery::DeliveryStrategyFactory.for(method, self)
      result = delivery_strategy.deliver

      apply NotificationDelivered.new(data: {
        notification_id: @id,
        delivery_method: method,
        delivered_at: result[:delivered_at],
        metadata: result[:metadata]
      })
    end

    def mark_as_read(delivery_method)
      apply NotificationMarkedAsRead.new(data: {
        notification_id: @id,
        delivery_method: delivery_method,
        read_at: Time.now
      })
    end

    def delivered?(method)
      @deliveries.key?(method)
    end

    attr_reader :id, :user_id, :content, :type, :delivery_methods

    private

    on NotificationCreated do |event|
      @user_id = event.data[:user_id]
      @content = event.data[:content]
      @type = event.data[:notification_type]
      @delivery_methods = event.data[:delivery_methods]
      @cta_text = event.data[:cta_text]
      @cta_url = event.data[:cta_url]
    end

    on NotificationDelivered do |event|
      @deliveries[event.data[:delivery_method]] = {
        delivered_at: event.data[:delivered_at],
        metadata: event.data[:metadata]
      }
    end

    on NotificationMarkedAsRead do |event|
      @deliveries[event.data[:delivery_method]][:read_at] = event.data[:read_at]
    end
  end
end
