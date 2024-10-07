module Integrations
  class GitcoinPassportScoresController
    def get_signing_message
      api.get_signing_message
    end

    def submit_passport
      api.submit_passport
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
