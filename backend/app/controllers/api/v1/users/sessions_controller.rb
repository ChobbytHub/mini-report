class Api::V1::Users::SessionsController < Devise::SessionsController
  respond_to :json

  # ログイン成功時
  def create
    user = User.find_for_database_authentication(email: params[:user][:email])
    if user&.valid_password?(params[:user][:password])
      token = JWT.encode({ user_id: user.id }, Rails.application.secret_key_base)
      render json: { message: 'Logged in successfully', user: user, token: token }, status: :ok
    else
      render json: { message: 'Invalid email or password' }, status: :unauthorized
    end
  end

  # ログアウト時
  def destroy
    render json: { message: 'Logged out successfully' }, status: :ok
  end
end
