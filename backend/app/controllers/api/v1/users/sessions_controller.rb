class Api::V1::Users::SessionsController < Devise::SessionsController
  respond_to :json

  private

  def respond_with(resource, _opts = {})
    token = JWT.encode({ user_id: resource.id }, Rails.application.secret_key_base)
    render json: {
      message: 'Logged in successfully',
      user: resource,
      token: token
    }, status: :ok
  end

  def respond_to_on_destroy
    render json: { message: 'Logged out successfully.' }, status: :ok
  end
end
