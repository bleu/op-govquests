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

    def get_delegatees(address_or_ens)
      handle_response(self.class.get("/delegates/#{address_or_ens}/delegatees", @options))
    end

    def get_delegators(address_or_ens)
      handle_response(self.class.get("/delegates/#{address_or_ens}/delegators", @options))
    end
  end
end
