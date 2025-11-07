module Api
  module V1
    class PostsController < ApplicationController
      before_action :authenticate_user!, except: [:index, :show]
      before_action :set_post, only: [:show, :destroy]

      def index
        posts = Post.includes(:user, :hoorays).order(created_at: :desc)
        render json: posts.as_json(include: { user: { only: [:id, :name] }, hoorays: { only: [:user_id] } })
      end

      def show
        render json: @post.as_json(include: { user: { only: [:id, :name, :bio] }, hoorays: { only: [:user_id] } })
      end

      def create
        post = current_user.posts.build(post_params)
        if post.save
          render json: post, status: :created
        else
          render json: { errors: post.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        if @post.user_id == current_user.id
          @post.destroy
          head :no_content
        else
          render json: { error: 'Not authorized' }, status: :unauthorized
        end
      end

      private

      def set_post
        @post = Post.find(params[:id])
      end

      def post_params
        params.require(:post).permit(:content)
      end
    end
  end
end
