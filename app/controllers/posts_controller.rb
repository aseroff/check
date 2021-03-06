# frozen_string_literal: true

# Controller for Posts
class PostsController < ApplicationController
  before_action :set_post_and_comments, only: %i[show edit update destroy]
  before_action :must_be_logged_in, only: [:new]
  before_action :must_be_owner, only: %i[edit update destroy]

  # GET /posts
  # GET /posts.json
  def index
    if current_user
      @user = current_user
      if params[:term]
        @term = params[:term]
        @posts = Post.search(@term).order(created_at: :desc).paginate(page: params[:page], per_page: 10)
      else
        @posts = Post.where('user_id IN (?)', (@user.following_users + [@user])).order(created_at: :desc).paginate(page: params[:page], per_page: 10)
      end
      @following = @user.following.size.to_s
      @followers = @user.followers.size.to_s
      @posts_count = @user.posts.size.to_s
      @favorited_count = @user.favorites.size.to_s
      @owned_count = @user.owned.size.to_s
      @popular_with_friends = @user.popular_with_friends
      @most_popular = Game.popular
    end
    respond_to do |format|
      format.html
      format.json.array! @posts, partial: 'post.json'
      format.js
    end
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
    @user = @post.user
    @following = @user.following.size.to_s
    @followers = @user.followers.size.to_s
    @posts_count = @user.posts.size.to_s
    @favorited_count = @user.favorites.size.to_s
    @owned_count = @user.owned.size.to_s
    @relation = Relation.find_by(user_id: current_user.id, related_id: @post.id, relationship: 'nice') if current_user
    respond_to do |format|
      format.html
      format.amp
      format.json.partial! 'post.json', as: @post
      format.json
    end
  end

  # GET /posts/new
  def new
    if params[:game_id]
      @game = Game.find(params[:game_id])
      @post = Post.new(user_id: current_user.id, game_id: params[:game_id])
    else
      redirect_to :root
    end
  end

  # GET /posts/1/edit
  def edit; end

  # POST /posts
  # POST /posts.json
  def create
    @post = Post.new(user_id: post_params[:user_id], game_id: post_params[:game_id], text: post_params[:text])

    respond_to do |format|
      if @post.save
        if post_params['tweet'].to_i == 1
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

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to @post, notice: 'Post was successfully updated.' }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post.destroy_associated
    @post.destroy
    respond_to do |format|
      format.html { redirect_to posts_url, notice: 'Post was successfully deleted.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_post_and_comments
    @post = Post.find(params[:id])
    @comments = @post.comments
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def post_params
    params.require(:post).permit(:user_id, :game_id, :text, :tweet)
  end

  def must_be_logged_in
    redirect_to new_user_session_path, notice: 'You must be logged in to do that.' unless current_user
  end

  def must_be_owner
    redirect_to posts_path, notice: "You can't do that." unless current_user && current_user == @post.user
  end
end
