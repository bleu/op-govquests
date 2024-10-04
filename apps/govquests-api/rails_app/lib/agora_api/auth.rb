module AgoraApi
  module Auth
    def get_nonce
      handle_response(self.class.get("/auth/nonce"))
    end

    def verify_siwe(message, signature, nonce)
      body = {message: message, signature: signature, nonce: nonce}
      handle_response(self.class.post("/auth/verify", @options.merge(body: body.to_json)))
    end
  end
end
