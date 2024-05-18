# app/controllers/concerns/authentication_concern.rb

module AuthenticationConcern
  extend ActiveSupport::Concern

  def encode_token(payload)
    JWT.encode(payload, ENV.fetch("JWT_KEY"))
  end

  def decode_token
    auth_header = request.headers['Authorization']
    if auth_header
      begin
        token = auth_header.split(' ').last
        JWT.decode(token, ENV.fetch("JWT_KEY"), true, algorithm: 'HS256')
      rescue 
        head :unauthorized
      end
    end
  end

  private

  def authenticate_user!
    head :forbidden unless user_sign_in?
  end

  def current_user
    decoded_token_info = decode_token
    return unless decoded_token_info

    begin
      user_id = decoded_token_info.first['user_id']
      user = User.find_by(id: user_id)
      Current.user ||= user
    rescue
      head :unauthorized
    end
  end

  def user_sign_in?
    current_user.present?
  end

  def login(user)
    Current.user = user
    reset_session
    encode_token({user_id: user.id})
  end

  def logout(user)
    Current.user = nil
    encode_token({user_id: Faker::Internet.password})
    reset_session
  end
end
