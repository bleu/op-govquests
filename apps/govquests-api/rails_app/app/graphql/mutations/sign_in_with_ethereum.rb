module Mutations
  class SignInWithEthereum < BaseMutation
    argument :signature, String, required: true

    field :user, Types::UserType, null: true
    field :errors, [String], null: false

    def resolve(signature:)
      message = ::Siwe::Message.from_json_string(context[:session][:siwe_message])

      if message.verify(signature, message.domain, message.issued_at, message.nonce)
        context[:session][:siwe_message] = nil

        user_id = SecureRandom.uuid

        Rails.configuration.command_bus.call(Authentication::RegisterUser.new(
          user_id:,
          email: nil,
          user_type: "non_delegate",
          address: message.address,
          chain_id: message.chain_id
        ))

        user = Authentication::UserReadModel.find_by(user_id:)

        context[:session][:user_id] = user_id

        {
          user: user,
          errors: []
        }
      else
        {
          user: nil,
          errors: ["Invalid signature"]
        }
      end
    rescue => e
      {
        user: nil,
        errors: [e.message]
      }
    end
  end
end
