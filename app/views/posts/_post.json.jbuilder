json.extract! post, :id, :text, :created_at, :updated_at
json.user post.user
json.game post.game
json.url post_url(post, format: :json)