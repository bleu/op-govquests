require_relative "action_strategy"

module ActionTracking
  class GitcoinScoreActionStrategy < ActionStrategy
    GITCOIN_SCORE_HUMANITY_THRESHOLD = 20

    def initialize(gitcoin_api:)
      @gitcoin_api = gitcoin_api
    end

    def start_execution(data)
      response = @gitcoin_api.get_signing_message

      {
        state: "started",
        nonce: response["nonce"],
        message: response["message"]
      }
    end

    def complete_execution(data)
      wallet_address = data["address"]
      signature = data["signature"]
      nonce = data["nonce"]

      response = @gitcoin_api.submit_passport(wallet_address, signature, nonce)
      score = response["score"].to_i

      if score > GITCOIN_SCORE_HUMANITY_THRESHOLD
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

    private

    def action_type
      "gitcoin_score"
    end

    def description
      "Complete Gitcoin Passport verification"
    end

    def action_data(data)
      {min_score: GITCOIN_SCORE_HUMANITY_THRESHOLD}
    end

    def verify_completion(data)
      data[:score] > GITCOIN_SCORE_HUMANITY_THRESHOLD
    end
  end
end
