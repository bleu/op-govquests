require_relative "base"

module ActionTracking
  module Strategies
    class SendEmail < Base
      def initialize(email_client: nil, start_data: nil, completion_data: nil)
        super(start_data:, completion_data:)
        @email_client = email_client
      end

      def start_data_valid?
        start_data[:email].present?
      end

      def on_start_execution
        token = SecureRandom.hex(16)

        @email_client.send_email_async(start_data[:email], token)

        start_data.merge({
          token:
        })
      end

      def can_complete?
        start_data_valid? && completion_data.present? && completion_data[:token] == start_data[:token]
      end
    end
  end
end
