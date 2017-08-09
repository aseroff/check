class UsersController < ApplicationController
  before_action :set_user, :count_stats, :find_relation

  def show
    @posts = @user.posts.order(created_at: :desc).paginate(page: params[:page], per_page: 5)
    respond_to do |format|
      format.html
      format.js
    end
  end

  def following
    ids = @user.following.pluck(:related_id)
    @users = User.for_ids_with_order(ids).paginate(page: params[:page], per_page: 5) 
    respond_to do |format|
      format.html
      format.js
    end
  end

  def followers
    ids = @user.followers.pluck(:user_id)
    @users = User.for_ids_with_order(ids).paginate(page: params[:page], per_page: 5) 
    respond_to do |format|
      format.html
      format.js
    end
  end

  def favorites
    ids = @user.favorites.pluck(:related_id)
    @games = Game.for_ids_with_order(ids).paginate(page: params[:page], per_page: 5) 
    respond_to do |format|
      format.html
      format.js
    end
  end

  def owned
    ids = @user.owned.pluck(:related_id)
    @games = Game.for_ids_with_order(ids).paginate(page: params[:page], per_page: 5) 
    respond_to do |format|
      format.html
      format.js
    end
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
