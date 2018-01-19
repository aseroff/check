json.array!(@posts) do |post|
	json.extract! post, :id, :text, :created_at, :updated_at
	json.user post.user
	json.game post.game
	json.url post_url(post, format: :json)
	json.comments post.comments do |comment|
		json.text comment.text
  		json.user_id comment.user_id
	end
	json.nices post.nices do |nice|
		json.username nice.user.username
		json.user_id nice.user_id
	end
end