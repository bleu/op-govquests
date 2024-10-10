module Mutations
  class SignInWithEthereum < BaseMutation
    argument :signature, String, required: true

    field :user, Types::UserType, null: true
    field :errors, [String], null: false

    def resolve(signature:)
      message = ::Siwe::Message.from_json_string(context[:session][:siwe_message])

      if message.verify(signature, message.domain, message.issued_at, message.nonce)
        user_id = Authentication.generate_user_id(message.address, message.chain_id)

        sign_in(user_id, signature)

        context[:session][:user_id] = user_id
        context[:session][:siwe_message] = nil

        user = Authentication::UserReadModel.find_by(user_id:)

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

    private

    def sign_in(user_id, signature)
      Rails.configuration.command_bus.call(
        Authentication::LogIn.new(
          user_id:,
          session_token: signature,
          timestamp: Time.now
        )
      )
    end
  end
end
