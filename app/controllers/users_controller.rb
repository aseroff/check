class UsersController < ApplicationController
  before_action :set_user, only: [:show, :update, :destroy]

  def show
    @following = @user.following
    @followers = @user.followers
  end

    private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user)
    end

end
