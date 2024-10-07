module Integrations
  class GitcoinPassportScoresController < ApplicationController
    def get_signing_message
      message = api.get_signing_message

      render json: {message: "Successfully fetched signing message", data: message, status: "success"}
    end

    def submit_passport
      address = params.require(:address)
      signature = params.require(:signature)
      nonce = params.require(:nonce)

      result = api.submit_passport(address, signature, nonce)

      render json: {message: "Successfully submitted passport", data: result, status: "success"}
    end

    private

    memoize def api
      gitcoin_keys = Rails.application.credentials.gitcoin_api

      GitcoinPassportApi.new(
        gitcoin_keys.api_key,
        gitcoin_keys.scorer_id
      )
    end
  end
end

# TODOS
# - first do e2e flow with gitcoin and a custom frontend page - DONE
# - then, connect this custom frontend page with the action tracking domain
# - then, connect the action tracking domain with the gitcoin passport scores controller
# - then, connect this with the actual frontend in an actual quest
# - then, write tests
