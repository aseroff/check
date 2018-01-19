module Api
  class UsersController < ApplicationController
    protect_from_forgery with: :null_session

    def show
      @user = User.friendly.find(params[:id] || params[:user_id])
      @posts = @user.posts.order(created_at: :desc).paginate(page: params[:page], per_page: 10)
      respond_to do |format|
        format.json { render :template => "api/users/user.json" }
      end
    end

  end
end
