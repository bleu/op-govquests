require "httparty"

class GitcoinPassportApi
  include HTTParty
  base_uri "https://api.scorer.gitcoin.co"

  def initialize(api_key = Rails.application.credentials.gitcoin_api.api_key, scorer_id = Rails.application.credentials.gitcoin_api.scorer_id)
    @headers = {"X-API-KEY" => api_key}
    @scorer_id = scorer_id
  end

  def get_signing_message
    self.class.get("/registry/signing-message", headers: @headers)
  end

  def submit_passport(address, signature = nil, nonce = nil)
    body = {
      address: address,
      scorer_id: @scorer_id,
      signature: signature,
      nonce: nonce
    }.compact
    self.class.post("/registry/submit-passport", headers: @headers, body: body.to_json)
  end

  def get_score(address)
    self.class.get("/registry/score/#{@scorer_id}/#{address}", headers: @headers)
  end

  def get_all_scores(options = {})
    query = options.slice(:last_score_timestamp_gt, :last_score_timestamp_gte, :limit, :offset)
    self.class.get("/registry/score/#{@scorer_id}", headers: @headers, query: query)
  end

  def get_stamps(address, include_metadata: false, limit: nil)
    query = {include_metadata: include_metadata, limit: limit}.compact
    self.class.get("/registry/stamps/#{address}", headers: @headers, query: query)
  end

  def get_stamp_metadata
    self.class.get("/registry/stamp-metadata", headers: @headers)
  end

  def get_gtc_stake(address, round_id)
    self.class.get("/registry/gtc-stake/#{address}/#{round_id}", headers: @headers)
  end
end
