require_relative "action_strategy"
module ActionTracking
  class GitcoinScoreActionStrategy < ActionStrategy
    private

    def action_type
      "gitcoin_score"
    end

    def description
      "Complete Gitcoin Passport verification"
    end

    def action_data(data)
      {min_score: 20}
    end

    def start_execution(data)
      user_id = data[:user_id]
      wallet_address = data[:wallet_address]

      response = api.request_message(user_id, wallet_address)

      {
        state: "message_requested",
        nonce: response["nonce"],
        message: response["message"]
      }
    end

    def complete_execution(data)
      wallet_address = data[:wallet_address]
      signature = data[:signature]

      response = api.submit_signature(wallet_address, signature)
      score = response["score"]

      if score > 20
        {
          status: "completed",
          state: "done",
          score: score,
          message: "Gitcoin Passport verified successfully"
        }
      else
        {
          status: "failed",
          state: "done",
          score: score,
          message: "Gitcoin Passport score too low"
        }
      end
    end

    def verify_completion(data)
      data[:score] > 20
    end

    private

    def api
      @api ||= begin
        gitcoin_keys = Rails.application.credentials.gitcoin_api
        GitcoinPassport.new(gitcoin_keys.api_key, gitcoin_keys.scorer_id)
      end
    end
  end
end
