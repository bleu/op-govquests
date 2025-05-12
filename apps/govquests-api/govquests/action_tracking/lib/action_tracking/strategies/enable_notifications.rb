require_relative "base"

module ActionTracking
  module Strategies
    class EnableNotifications < Base
      def start_data_valid?
        true
      end

      def can_complete?
        false
      end

      def completion_data_valid?
        completion_data[:email_notifications] && completion_data[:telegram_notifications]
      end
    end
  end
end
