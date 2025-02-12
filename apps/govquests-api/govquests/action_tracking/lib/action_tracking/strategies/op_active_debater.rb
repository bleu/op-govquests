module ActionTracking
  module Strategies
    class OpActiveDebater < Base
      include Infra::Import["services.discourse"]
      include ActionView::Helpers::SanitizeHelper

      MIN_WORD_COUNT = 50
      MIN_QUALIFYING_POSTS = 2

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
        return false unless qualifying_posts.any?
        return false unless qualifying_posts.size >= MIN_QUALIFYING_POSTS

        true
      end

      private

      def qualifying_posts
        @qualifying_posts ||= begin
          activity = discourse.fetch_user_activity(start_data[:username])
          activity.select do |post|
            next unless post["username"] == start_data[:username]
            next unless strip_tags(post["cooked"]).split.size >= MIN_WORD_COUNT

            true
          end
        end
      rescue => e
        Rails.logger.error("Error fetching discourse posts: #{e.message}")
        []
      end
    end
  end
end