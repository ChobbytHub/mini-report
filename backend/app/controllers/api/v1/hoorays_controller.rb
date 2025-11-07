module Api
  module V1
    class HooraysController < ApplicationController
      before_action :authenticate_user!
      before_action :set_post

      def create
        hooray = @post.hoorays.build(user: current_user)
        if hooray.save
          render json: { message: 'Hooray!' }, status: :created
        else
          render json: { errors: hooray.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        hooray = @post.hoorays.find_by(user: current_user)
        if hooray
          hooray.destroy
          head :no_content
        else
          render json: { error: 'Hooray not found' }, status: :not_found
        end
      end

      private

      def set_post
        @post = Post.find(params[:post_id])
      end
    end
  end
end
