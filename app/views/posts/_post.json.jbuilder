# frozen_string_literal: true

json.extract! post, :id, :text, :created_at, :updated_at
json.user post.user
json.game post.game
json.url post_url(post, format: :json)
json.comments post.comments do |comment|
  json.text comment.text
  json.partial! 'users/user', user: comment.user
end
json.nices post.nices do |nice|
  json.username nice.user.username
  json.user_id nice.user_id
end
