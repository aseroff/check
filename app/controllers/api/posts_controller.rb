module Api
  class PostsController < ApplicationController
    before_action :set_post_and_comments, only: [:show, :edit, :update, :destroy]
    before_action :must_be_logged_in, only: [:new]
    before_action :must_be_owner, only: [:edit, :update, :destroy]

    # GET /posts
    # GET /posts.json
    def index
      current_user = User.find_by(access_token: params[:access_token])
      if current_user
        @user = current_user
        if params[:term]
          @term = params[:term]
          @posts = Post.search(@term).order(created_at: :desc).paginate(page: params[:page], per_page: 10)
        else
          @posts = Post.where("user_id IN (?)", (@user.following_users + [@user])).order(created_at: :desc).paginate(page: params[:page], per_page: 10)
        end
      end
      respond_to do |format|
        format.html
        format.json.array! @posts, partial: "post.json"
        format.js
      end
    end
  end
end