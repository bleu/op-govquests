# typed: true
# frozen_string_literal: true

module ActionTracking
  module Strategies
    class OpForumContributor < Base
      include Import["services.discourse"]      
      include ActionView::Helpers::SanitizeHelper

      MIN_POST_LENGTH = 200
      LIKE_ACTION_ID = 2

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
        true
      end

      private

      def qualifying_posts
        @qualifying_posts ||= begin
          activity = discourse.fetch_user_activity(start_data[:username])
          activity.select do |post|
            next unless post["username"] == start_data[:username]
            next unless strip_tags(post["cooked"])&.length&.>= MIN_POST_LENGTH
            next unless get_like_count(post) > 0

            true
          end
        end
      rescue => e
        Rails.logger.error("Error fetching discourse posts: #{e.message}")
        []
      end

      def get_like_count(post)
        post["actions_summary"]&.find { |action| action["id"] == LIKE_ACTION_ID }&.fetch("count", 0) || 0
      end
    end
  end
end
