module Api
  module V1
    class SessionsController < ApplicationController
      skip_before_action :authenticate_user!, only: [:create]

      # POST /api/v1/login
      def create
        user = User.find_by(email: params.dig(:user, :email))

        if user&.valid_password?(params.dig(:user, :password))
          # JWTトークン生成（有効期限24時間）
          payload = { user_id: user.id, exp: 24.hours.from_now.to_i }
          token = JsonWebToken.encode(payload)

          render json: {
            message: "Logged in successfully",
            user: {
              id: user.id,
              email: user.email,
              name: user.name
            },
            token: token
          }, status: :ok
        else
          render json: { error: "Invalid email or password" }, status: :unauthorized
        end
      end

      # DELETE /api/v1/logout
      def destroy
        # JWTはステートレスなので、ログアウト時はフロント側でトークンを削除
        render json: { message: "Logged out" }, status: :ok
      end
    end
  end
end
