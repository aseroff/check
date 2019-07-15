# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :ignore_newrelic, if: :amp_request?
  before_action :determine_notifications

  def about
    respond_to do |format|
      format.html
      format.amp
    end
  end

  def cookies
    respond_to do |format|
      format.html
      format.amp
    end
  end

  def privacy
    respond_to do |format|
      format.html
      format.amp
    end
  end

  def terms
    respond_to do |format|
      format.html
      format.amp
    end
  end

  def investors
    respond_to do |format|
      format.html
      format.amp
    end
  end

  def stats; end

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
    devise_parameter_sanitizer.permit(:account_update) { |u| u.permit(:username, :email, :password, :password_confirmation, :current_password, :avatar, :avatar_cache, :remove_avatar, :uid, :provider, :twitter_token, :twitter_token_secret) }
  end

  def determine_notifications
    @notifications = current_user.notifications if current_user
  end
end
