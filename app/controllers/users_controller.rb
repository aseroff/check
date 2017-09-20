class UsersController < ApplicationController
  before_action :set_user, except: [:index, :notifications]
  before_action :count_stats, except: [:index, :notifications, :disconnect]
  before_action :find_relation, except: [:index, :notifications, :disconnect]

  def index
    if params[:filter]
      @filter = params[:filter]
      if @filter == "twitter" && current_user
        @users = current_user.friends_from_twitter.paginate(page: params[:page], per_page: 10) 
      end
    elsif params[:term]
      @users = User.search(params[:term]).paginate(page: params[:page], per_page: 10) 
    else
      @users = User.none
    end
    respond_to do |format|
      format.html
      format.json.array! @users, partial: "user.json"
      format.js
    end
  end

  def show
    @posts = @user.posts.order(created_at: :desc).paginate(page: params[:page], per_page: 5)
    respond_to do |format|
      format.html
      format.json.partial! "user.json", as: @user
      format.js
    end
  end

  def notifications
    @user = current_user
    @notifications.update_all(updated_at: Time.now)
  end

  def following
    ids = @user.following.pluck(:related_id)
    @users = User.for_ids_with_order(ids).paginate(page: params[:page], per_page: 10) 
    respond_to do |format|
      format.html
      format.json.array! @users, partial: "user.json"
      format.js
    end
  end

  def followers
    ids = @user.followers.pluck(:user_id)
    @users = User.for_ids_with_order(ids).paginate(page: params[:page], per_page: 10) 
    respond_to do |format|
      format.html
      format.json.array! @users, partial: "user.json"
      format.js
    end
  end

  def favorites
    ids = @user.favorites.pluck(:related_id)
    @games = Game.for_ids_with_order(ids).paginate(page: params[:page], per_page: 10) 
    respond_to do |format|
      format.html
      format.json.array! @games, partial: "game.json"
      format.js
    end
  end

  def owned
    ids = @user.owned.pluck(:related_id)
    @games = Game.for_ids_with_order(ids).paginate(page: params[:page], per_page: 10) 
    respond_to do |format|
      format.html
      format.json.array! @games, partial: "game.json"
      format.js
    end
  end

  def disconnect
    @user.update(uid: nil, provider: nil)
    redirect_to edit_user_registration_path, notice: "Account disconnected."
  end

    private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.friendly.find(params[:id] || params[:user_id])
    end

    def find_relation
      @relation = Relation.find_by(user_id: current_user.id, related_id: @user.id, relationship:"follow") if current_user
    end

    def count_stats
      @following = @user.following.size.to_s
      @followers = @user.followers.size.to_s
      @posts_count = @user.posts.size.to_s
      @favorited_count = @user.favorites.size.to_s
      @owned_count = @user.owned.size.to_s
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user)
    end
end
