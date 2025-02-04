module ActionTracking
  module Strategies
    class OpActiveDebater < Base
      include Import["services.discourse"]

      def start_data_valid? 
        discourse_verification = start_data[:discourse_verification]

        return false unless discourse_verification.present?
        return false unless discourse_verification.status == "completed"
        return false unless discourse_verification.completion_data["discourse_username"].present?

        true
      end

      def on_start_execution
        {
          username: start_data[:discourse_verification].completion_data["discourse_username"]
        }
      end

      def can_complete?
        
      end
    end
  end
end