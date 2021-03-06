# frozen_string_literal: true

user = user_relation.related_item
json.extract! user, :id, :username, :avatar
json.url user_url(user, format: :json)
