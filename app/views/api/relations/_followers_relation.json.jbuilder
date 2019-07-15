# frozen_string_literal: true

user = user_relation.user
json.extract! user, :id, :username, :avatar
json.url user_url(user, format: :json)
