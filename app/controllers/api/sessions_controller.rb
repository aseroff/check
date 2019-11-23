# frozen_string_literal: true

# Controller for mobile application sessions
class Api::SessionsController < ApplicationController
  # If user login data are valid it will return the access_token so the
  # client app can use it for future request for the specific user.
  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user&.valid_password?(params[:session][:password])
      access_token = SecureRandom.urlsafe_base64
      user.update(access_token: access_token)
      render json: user.access_token, status: :ok
    else
      render json: 'Email and password combination are invalid', status: :unprocessable_entity
    end
  end

  # Verifies the access_token so the client app would know if to login the user.
  def verify_access_token
    user = User.find_by(access_token: params[:session][:access_token])
    if user
      render json: user, status: :ok
    else
      render json: 'Token failed verification', status: :unprocessable_entity
    end
  end
end
