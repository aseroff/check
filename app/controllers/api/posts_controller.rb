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
        format.json.array! @posts, partial: "post.json"
      end
    end

    def create
      @post = Post.new(user_id: @current_user.id, game_id: post_params[:game_id], text: post_params[:text])

      respond_to do |format|
        if @post.save
          if post_params["tweet"].to_i == 1
            tweet_id = current_user.tweet(@post)
            format.html { redirect_to @post, notice: 'Thanks for sharing your check in! You can see it <a target="0" href="http://twitter.com/statuses/' + tweet_id.to_s + '">here</a>.' }
            format.json { render :show, status: :created, location: @post }
          else
            format.html { redirect_to @post, notice: 'Check-in created!' }
            format.json { render :show, status: :created, location: @post }
          end
        else
          format.html { render :new }
          format.json { render json: @post.errors, status: :unprocessable_entity }
        end
      end
    end
  private
    def look_up_authenticated_user
      @current_user = User.find_by(access_token: params[:access_token])
    end

  end
end