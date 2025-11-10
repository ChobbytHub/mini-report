# app/controllers/api/v1/registrations_controller.rb
module Api
  module V1
    class RegistrationsController < ApplicationController
      # APIモードでは verify_authenticity_token は不要
      respond_to :json

      def create
        user = User.new(sign_up_params)

        if user.save
          # JWT生成
          token = Warden::JWTAuth::UserEncoder.new.call(user, :user, nil)
          render json: {
            message: 'User created successfully',
            user: {
              id: user.id,
              name: user.name,
              email: user.email
            },
            token: token[0]
          }, status: :created
        else
          render json: {
            message: 'User creation failed',
            errors: user.errors.full_messages
          }, status: :unprocessable_entity
        end
      end

      private

      def sign_up_params
        params.require(:user).permit(:name, :email, :password, :password_confirmation)
      end
    end
  end
end
