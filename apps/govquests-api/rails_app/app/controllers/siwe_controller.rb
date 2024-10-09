class SiweController < ApplicationController
  def nonce
    render plain: SecureRandom.hex(32)
  end

  def verify
    user = Authentication::UserReadModel.authenticate_with_siwe(params[:message], params[:signature])

    # token = generate_jwt(user)
    # render json: {token: token}
    render json: {success: true}, status: :ok
  rescue Siwe::ExpiredMessage
    render json: {error: "Expired message"}, status: :unauthorized
  rescue Siwe::NotValidMessage
    render json: {error: "Invalid message or signature"}, status: :unauthorized
  rescue => e
    render json: {error: e.message}, status: :bad_request
  end

  private

  def generate_jwt(user)
    payload = {
      user_id: user.user_id,
      wallet_address: user.wallets.first["wallet_address"],
      exp: 24.hours.from_now.to_i
    }
    JWT.encode(payload, Rails.application.secrets.secret_key_base)
  end
end
