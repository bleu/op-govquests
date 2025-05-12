require_relative "base"

module ActionTracking
  module Strategies
    class EnableNotifications < Base
      def start_data_valid?
        start_data[:email_notifications] && start_data[:telegram_notifications]
      end

      def can_complete?
        start_data_valid?
      end
    end
  end
end
