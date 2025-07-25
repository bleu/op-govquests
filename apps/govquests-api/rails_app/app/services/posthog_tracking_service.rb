class PosthogTrackingService
  class << self
    def track_event(event_name, properties = {}, distinct_id = nil)
      return unless Rails.env.production? || Rails.env.staging?

      begin
        posthog_client.capture(
          distinct_id: distinct_id || SecureRandom.uuid,
          event: event_name,
          properties: properties.merge(
            environment: Rails.env,
            timestamp: Time.current.iso8601
          )
        )
      rescue => e
        Rails.logger.error("PostHog tracking error: #{e.message}")
      end
    end

    private

    def posthog_client
      @posthog_client ||= PostHog::Client.new(
        api_key: Rails.application.credentials.posthog.api_key,
        host: Rails.application.credentials.posthog.host,
        on_error: proc { |status, msg| Rails.logger.error("PostHog error: #{msg}") }
      )
    end
  end
end
