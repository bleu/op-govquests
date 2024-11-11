require_relative "base"

module ActionTracking
  module Strategies
    class SendEmail < Base
      def start_data_valid?
        # TODO: OP-473, check if email is a valid email address
        start_data[:email].present?
      end

      def can_complete?
        start_data_valid?
      end
    end
  end
end
