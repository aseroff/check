json.extract! post, :id, :user_id, :game_id, :subtype, :created_at, :updated_at
json.url post_url(post, format: :json)
