module ActionTracking
  module Strategies
    class DiscourseVerification < Base
      include Import["services.discourse"]

      def start_execution
        credentials = discourse.generate_auth_credentials

        {
          action_type: "discourse_verification",
          private_key: credentials[:private_key],
          nonce: credentials[:nonce],
          verification_url: credentials[:auth_url]
        }
      end

      def complete_execution(dry_run: false)
        return false if dry_run

        raise CompletionDataVerificationFailed, "No encrypted key provided" if completion_data[:encrypted_key].blank?

        data = discourse.decrypt_api_key(completion_data[:encrypted_key], start_data["private_key"])
        api_key = data["key"]
        discourse_username = discourse.fetch_current_user(api_key)

        {
          action_type: "discourse_verification",
          discourse_username: discourse_username,
          api_key: api_key
        }
      end
    end
  end
end
