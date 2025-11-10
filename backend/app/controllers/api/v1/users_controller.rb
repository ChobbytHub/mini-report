module Api
  module V1
    class UsersController < ApplicationController
      # GET /api/v1/me
      def me
        if @current_user
          render json: {
            id: @current_user.id,
            email: @current_user.email,
            name: @current_user.name
          }, status: :ok
        else
          render json: { error: 'Not authorized' }, status: :unauthorized
        end
      end
    end
  end
end
