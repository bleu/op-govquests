module Notifications
  module Delivery
    class Base
      def initialize(notification)
        @notification = notification
      end

      def deliver
        raise NotImplementedError
      end

      protected

      attr_reader :notification
    end

    class InAppDelivery < Base
      def deliver
        # In real implementation, this might push to a websocket or similar
        # For now, we'll just emit a delivery event
        {
          delivery_method: "in_app",
          delivered_at: Time.now,
          metadata: {
            user_id: notification.user_id
          }
        }
      end
    end

    class EmailDelivery < Base
      def deliver
        # In real implementation, this would use ActionMailer or similar
        # For now, we'll just emit a delivery event
        {
          delivery_method: "email",
          delivered_at: Time.now,
          metadata: {
            to: fetch_user_email,
            subject: notification.type
          }
        }
      end

      private

      def fetch_user_email
        # In real implementation, this would fetch from user record
        "user@example.com"
      end
    end

    class SmsDelivery < Base
      def deliver
        # In real implementation, this would use Twilio or similar
        # For now, we'll just emit a delivery event
        {
          delivery_method: "sms",
          delivered_at: Time.now,
          metadata: {
            to: fetch_user_phone,
            provider: "twilio"
          }
        }
      end

      private

      def fetch_user_phone
        # In real implementation, this would fetch from user record
        "+1234567890"
      end
    end

    class DeliveryStrategyFactory
      class UnknownDeliveryMethodError < StandardError; end

      STRATEGIES = {
        "in_app" => InAppDelivery,
        "email" => EmailDelivery,
        "sms" => SmsDelivery
      }.freeze

      def self.for(method, notification)
        strategy_class = STRATEGIES[method]
        raise UnknownDeliveryMethodError, "Unknown delivery method: #{method}" unless strategy_class

        strategy_class.new(notification)
      end
    end
  end
end
