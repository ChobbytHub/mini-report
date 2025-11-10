class ApplicationController < ActionController::API
  include ActionController::MimeResponds

  before_action :authenticate_user!

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :email, :password, :password_confirmation])
    devise_parameter_sanitizer.permit(:sign_in, keys: [:email, :password])
    devise_parameter_sanitizer.permit(:account_update, keys: [:password, :password_confirmation])
  end

  private

  def authenticate_user!
    header = request.headers['Authorization']
    token = header.split(' ').last if header.present?

    decoded = JsonWebToken.decode(token)

    if decoded && decoded[:user_id]
      @current_user = User.find_by(id: decoded[:user_id])
      render json: { error: 'Unauthorized' }, status: :unauthorized unless @current_user
    else
      render json: { error: 'Token expired or invalid' }, status: :unauthorized
    end
  end
end
