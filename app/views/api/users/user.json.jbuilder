# frozen_string_literal: true

json.extract! @user, :id, :username, :avatar
json.url user_url(@user, format: :json)
json.following_count @following
json.followers_count @followers
json.posts_count @posts_count
json.favorited_count @favorited_count
json.owned_count @owned_count
json.posts @posts, partial: 'posts/post', as: :post
