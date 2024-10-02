# app/read_models/client_authentication/create_user.rb
module Authentication
  class OnCreateUser
    def call(event)
      user_id = event.data.fetch(:user_id)
      email = event.data[:email]
      user_type = event.data[:user_type]

      User.find_or_create_by(user_id: user_id).update(
        email: email,
        user_type: user_type
      )
    end
  end
end
