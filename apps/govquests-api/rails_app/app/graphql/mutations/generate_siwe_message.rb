module Mutations
  class GenerateSiweMessage < BaseMutation
    argument :address, String, required: true
    argument :chain_id, Integer, required: true

    field :message, String, null: false
    field :nonce, String, null: false

    def resolve(address:, chain_id:)
      nonce = ::Siwe::Util.generate_nonce
      message = ::Siwe::Message.new(
        "http://localhost:3000",
        address,
        "http://localhost:3000",
        "1",
        {
          statement: "SIWE Rails Example",
          nonce: nonce,
          chain_id: chain_id
        }
      )

      context[:session][:siwe_message] = message.to_json_string

      {
        message: message.prepare_message,
        nonce: nonce
      }
    end
  end
end
