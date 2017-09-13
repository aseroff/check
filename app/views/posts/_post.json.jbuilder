json.extract! post, :id, :user_id, :game_id, :text, :created_at, :updated_at
json.url post_url(post, format: :json)