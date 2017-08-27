class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def twitter
    if current_user
      current_user.update(
        twitter_token: request.env["omniauth.auth"]["credentials"]["token"], 
        twitter_token_secret: request.env["omniauth.auth"]["credentials"]["secret"], 
        provider: request.env["omniauth.auth"]["provider"],
        uid: request.env["omniauth.auth"]["uid"]
      )
      redirect_to edit_user_registration_url, :event => :authentication
      set_flash_message(:notice, :success, :kind => "Twitter")
    else
      @user = User.from_omniauth(request.env["omniauth.auth"])
      if @user.persisted?
        sign_in_and_redirect @user, :event => :authentication
        set_flash_message(:notice, :success, :kind => "Twitter")
        session["devise.twitter_data"] = request.env["omniauth.auth"].except("extra")
      else
        session["devise.twitter_data"] = request.env["omniauth.auth"].except("extra")
        redirect_to new_user_registration_url
      end
    end
  end

  def failure
    redirect_to root_path
  end

end