class UsersController < ApplicationController
  before_action :set_user, :count_follows

  def show
    @posts = @user.posts.order(created_at: :desc)
  end

  def following
    @users = @user.following.map {|f| User.find(f.related_id) }
  end

  def followers
    @users = @user.followers.map {|f| f.user }
  end

    private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.friendly.find(params[:id] || params[:user_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user)
    end

    def count_follows
      @following = @user.following.size.to_s
      @followers = @user.followers.size.to_s
    end

end
