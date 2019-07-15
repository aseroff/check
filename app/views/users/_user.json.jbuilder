# frozen_string_literal: true

json.extract! user, :id, :username, :avatar
json.url user_url(user, format: :json)
