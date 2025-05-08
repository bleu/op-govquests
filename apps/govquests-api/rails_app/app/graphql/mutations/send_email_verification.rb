module Mutations
  class SendEmailVerification < BaseMutation
    argument :email, String, required: true

    field :success, Boolean, null: false
    field :errors, [String], null: false

    def resolve(email:)
      user = context[:current_user]
      current_email = user.email
      new_email = email

      if current_email == new_email
        return {success: false, errors: ["Email already verified"]}
      end

      if new_email.blank?
        return {success: false, errors: ["Email is required"]}
      end

      token = SecureRandom.hex(16)

      Authentication::VerifyEmailClient.send_email_async(new_email, token)

      user.update(email: nil, email_verification_token: token)

      {
        success: true,
        errors: []
      }
    rescue => e
      {
        success: false,
        errors: [e.message]
      }
    end
  end
end
