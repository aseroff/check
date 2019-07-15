# frozen_string_literal: true

require File.expand_path('../config/environment', __dir__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  def sign_in(user)
    post user_session_path \
      'user[email]' => user.email,
      'user[password]' => 'password'
  end
  # Add more helper methods to be used by all tests here...
end
