require_relative "../container"

module Gamification
  module Strategies 
    class Base
      def initialize(badge_data: nil, user_id: nil)
        @badge_data = badge_data&.with_indifferent_access
        @user_id = user_id
      end

      def verify_completion?
        raise NotImplementedError, "#{self.class} must implement #verify_completion?"
      end

      def validate_badge_data
        true
      end

      def validate_user
        true
      end

      def format_error(message)
        { error: message, code: generate_error_code }
      end

      private

      attr_reader :badge_data, :user_id

      def fetch_user_data
        # Implement logic to fetch user-related data needed for verification
      end

      def generate_error_code
        "#{self.class.name.demodulize.underscore}_error"
      end
    end
  end
end