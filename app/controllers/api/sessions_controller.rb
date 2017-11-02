module Api
  class SessionsController < ApplicationController

    #If user login data are valid it will return the access_token so the
    #client app can use it for future request for the specific user.
    def create
      user = User.find_by(email: params[:session][:email].downcase)
        if user && user.authenticate(params[:session][:password])
          access_token = SecureRandom.urlsafe_base64
          user.update(access_token: access_token)
          render text: user.access_token, status: 200
        else
          render text: "Email and password combination are invalid", status: 422
        end
    end

    #Verifies the access_token so the client app would know if to login the user.
    def verify_access_token
        if User.find_by(email: params[:session][:email].downcase).access_token == params[:session][:access_token]
          render text: "verified", status: 200
        else
          render text: "Token failed verification", status: 422
        end
    end

  end
end
