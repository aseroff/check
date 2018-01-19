module Api
  class UsersController < ApplicationController
    before_action :set_user, only: [:show, :edit, :update, :destroy]
    before_action :look_up_authenticated_user

    def show
      @posts = @user.posts.order(created_at: :desc).paginate(page: params[:page], per_page: 10)
      respond_to do |format|
        format.json { render :template => "api/users/user.json" }
      end
    end

    def notifications
      @notifications = @current_user.notifications
      respond_to do |format|
        format.json
      end
    end

  end

  private
    def set_user
      @user = User.friendly.find(params[:id] || params[:user_id])
    end

    def look_up_authenticated_user
      @current_user = User.find_by(access_token: params[:access_token])
    end
end
