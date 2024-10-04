# lib/action_tracking/strategy/gitcoin_score_action_strategy.rb
module ActionTracking
  class GitcoinScoreActionStrategy < ActionStrategy
    def initialize(action, event)
      @action = action
      @event = event
    end

    def execute(action, event)
      # 1. Request nonce and message from Gitcoin API
      response = GitcoinApi.request_message(event.user_id, event.wallet_address)
      action.update(state: "message_requested", nonce: response["nonce"], message: response["message"])
    end

    def complete(action, event)
      # 2. Submit signed message to Gitcoin API and get score
      response = GitcoinApi.submit_signature(event.wallet_address, event.signature)
      score = response["score"]

      # 3. Check if the score meets criteria
      if score > 20
        action.update(state: "done", status: "completed")
      else
        action.update(state: "done", status: "failed")
      end
    end

    private

    memoize def api
      gitcoin_keys = Rails.application.credentials.gitcoin_api

      GitcoinPassport.new(
        gitcoin_keys.api_key,
        gitcoin_keys.scorer_id
      )
    end
  end
end
