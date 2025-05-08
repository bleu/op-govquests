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

    class TelegramDelivery < Base
      def deliver
        SendTelegramMessageJob.perform_now(@notification.id)

        {
          delivery_method: "telegram",
          delivered_at: Time.now,
          metadata: {
            chat_id: fetch_user_telegram_chat_id
          }
        }
      end

      private 

      def fetch_user_telegram_chat_id
        Authentication::UserReadModel.find_by(user_id: @notification.user_id).telegram_chat_id
      end
    end
    
    class DeliveryStrategyFactory
      class UnknownDeliveryMethodError < StandardError; end

      STRATEGIES = {
        "in_app" => InAppDelivery,
        "email" => EmailDelivery,
        "telegram" => TelegramDelivery
      }.freeze

      def self.for(method, notification)
        strategy_class = STRATEGIES[method]
        raise UnknownDeliveryMethodError, "Unknown delivery method: #{method}" unless strategy_class

        strategy_class.new(notification)
      end
    end
  end
end
