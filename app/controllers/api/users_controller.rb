module Api
  class UsersController < ApplicationController

    def show
      @posts = @user.posts.order(created_at: :desc).paginate(page: params[:page], per_page: 10)
      respond_to do |format|
        format.json
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
    def look_up_authenticated_user
      @current_user = User.find_by(access_token: params[:access_token])
    end
end
