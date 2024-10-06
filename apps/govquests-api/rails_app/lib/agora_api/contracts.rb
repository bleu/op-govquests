module AgoraApi
  module Contracts
    def get_governor_contract
      handle_response(self.class.get("/contracts/governor", @options))
    end

    def get_alligator_contract
      handle_response(self.class.get("/contracts/alligator", @options))
    end

    def get_voting_token_contract
      handle_response(self.class.get("/contracts/token", @options))
    end
  end
end
