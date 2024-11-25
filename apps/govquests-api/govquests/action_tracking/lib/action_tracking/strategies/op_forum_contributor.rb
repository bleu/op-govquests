# typed: true
# frozen_string_literal: true

module ActionTracking
  module Strategies
    class OpForumContributor < Base
      include Import["services.discourse"]

      MIN_POST_LENGTH = 200
      LIKE_ACTION_ID = 2

      private

      def can_start?
        # Only allow starting this action if the user has completed the "discourse_verification" action
        return false unless start_data[:discourse_verification].present?
        return false unless start_data[:discourse_verification][:verified]

        true
      end

      def start_data_valid?
        start_data[:username].present?
      end

      def on_start_execution
        start_data.merge({
          qualifying_posts:
        })
      end

      def can_complete?
        return false unless start_data_valid?
        return false unless start_data[:qualifying_posts].any?

        true
      end

      protected

      def qualifying_posts
        @qualifying_posts ||= begin
          activity = discourse.fetch_user_activity(start_data[:username])
          activity.select do |post|
            next unless post["username"] == start_data[:username]
            next unless post["cooked"]&.length&.>= MIN_POST_LENGTH
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
