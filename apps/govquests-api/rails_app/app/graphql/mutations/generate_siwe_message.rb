module Mutations
  class GenerateSiweMessage < BaseMutation
    argument :address, String, required: true
    argument :chain_id, Integer, required: true

    field :message, String, null: false
    field :nonce, String, null: false

    def resolve(address:, chain_id:)
      ensure_user_registered(address, chain_id)

      domain_url = Rails.application.credentials.dig(Rails.env.to_sym, :siwe_domain)
      nonce = ::Siwe::Util.generate_nonce
      message = ::Siwe::Message.new(
        domain_url,
        address,
        domain_url,
        "1",
        {
          statement: "Sign in to GovQuests",
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

    def ensure_user_registered(address, chain_id)
      user_id = Authentication.generate_user_id(address, chain_id)

      Rails.configuration.command_bus.call(
        Authentication::RegisterUser.new(
          user_id:,
          email: nil,
          user_type: "non_delegate",
          address:,
          chain_id:
        )
      )
    rescue
      nil
    end
  end
end
