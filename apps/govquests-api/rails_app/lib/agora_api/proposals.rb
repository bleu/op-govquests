module AgoraApi
  module Proposals
    def get_proposals(limit: 10, offset: 0, filter: nil)
      query = {limit: limit, offset: offset, filter: filter}.compact
      handle_response(self.class.get("/proposals", @options.merge(query: query)))
    end

    def fetch_all_proposals
      proposals = []
      limit = 50
      offset = 0

      loop do
        response = get_proposals(limit: limit, offset: offset)
        proposals += response["data"]
        break unless response["meta"]["has_next"]

        offset += limit
      end

      proposals
    end

    def get_proposal(proposal_id)
      handle_response(self.class.get("/proposals/#{proposal_id}", @options))
    end

    def get_proposal_votes(proposal_id, limit: 10, offset: 0, sort: nil)
      query = {limit: limit, offset: offset, sort: sort}.compact
      handle_response(self.class.get("/proposals/#{proposal_id}/votes", @options.merge(query: query)))
    end
  end
end
