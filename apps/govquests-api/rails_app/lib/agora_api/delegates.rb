module AgoraApi
  module Delegates
    def get_delegates(limit: 10, offset: 0, sort: nil)
      query = {limit: limit, offset: offset, sort: sort}.compact
      handle_response(self.class.get("/delegates", @options.merge(query: query)))
    end

    def get_delegate(address_or_ens)
      handle_response(self.class.get("/delegates/#{address_or_ens}", @options))
    end

    def get_delegate_votes(address_or_ens, limit: 10, offset: 0)
      query = {limit: limit, offset: offset}
      handle_response(self.class.get("/delegates/#{address_or_ens}/votes", @options.merge(query: query)))
    end

    def fetch_all_delegate_votes(address_or_ens)
      votes = []
      limit = 50
      offset = 0

      loop do
        response = get_delegate_votes(address_or_ens, limit: limit, offset: offset)
        votes += response["data"]
        break unless response["meta"]["has_next"]

        offset += limit
      end

      votes
    end

    def get_delegatees(address_or_ens)
      handle_response(self.class.get("/delegates/#{address_or_ens}/delegatees", @options))
    end

    def get_delegators(address_or_ens)
      handle_response(self.class.get("/delegates/#{address_or_ens}/delegators", @options))
    end
  end
end
