class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
 
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :ignore_newrelic, :if => :amp_request?

  def about
  end
  def cookies
  end
  def privacy
  end
  def terms
  end

  protected

  def ignore_newrelic
    NewRelic::Agent.ignore_transaction
    NewRelic::Agent.ignore_apdex
    NewRelic::Agent.ignore_enduser
  end

  def amp_request?
    request.format.try(:amp?)
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit(:username, :email, :password, :password_confirmation, :remember_me, :avatar, :avatar_cache, :uid, :provider, :twitter_token, :twitter_token_secret, :remote_avatar_url) }
    devise_parameter_sanitizer.permit(:account_update) { |u| u.permit(:username, :password, :password_confirmation, :current_password, :avatar, :avatar_cache, :remove_avatar, :uid, :provider, :twitter_token, :twitter_token_secret) }
  end

end
