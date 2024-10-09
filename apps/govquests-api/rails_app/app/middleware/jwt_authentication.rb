class JwtAuthentication
  def initialize(app)
    @app = app
  end

  def call(env)
    token = extract_token(env)
    if token
      begin
        payload = JWT.decode(token, Rails.application.secrets.secret_key_base)[0]
        env['current_user'] = Authentication::UserReadModel.find_by(user_id: payload['user_id'])
      rescue JWT::DecodeError
        # Invalid token
      end
    end
    @app.call(env)
  end

  private

  def extract_token(env)
    authorization = env['HTTP_AUTHORIZATION']
    if authorization && authorization.start_with?('Bearer ')
      authorization.split(' ').last
    end
  end
end

