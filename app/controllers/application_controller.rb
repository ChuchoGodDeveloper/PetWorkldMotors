class ApplicationController < ActionController::Base
  def current_usuario
    token = request.headers['Authorization']&.split(' ')&.last
    return nil unless token
    begin
      decoded = JWT.decode(token, Rails.application.secret_key_base, true, algorithm: 'HS256')
      Usuario.find_by(id: decoded[0]['usuario_id'])
    rescue JWT::DecodeError
      nil
    end
  end
end