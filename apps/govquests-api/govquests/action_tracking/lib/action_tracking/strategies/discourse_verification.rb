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
        private_key = start_data["private_key"]
        raise CompletionDataVerificationFailed, "Private key not found" if private_key.nil?

        begin
          user_data = discourse.verify_user(completion_data[:encrypted_key], private_key)

          {
            action_type: "discourse_verification",
            discourse_username: user_data[:username],
            api_key: user_data[:api_key]
          }
        rescue Services::Discourse::Error => e
          raise CompletionDataVerificationFailed, "Error verifying user: #{e.message}"
        end
      end
    end
  end
end
