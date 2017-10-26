json.extract! post, :id, :text, :created_at, :updated_at
json.user post.user
json.game post.game
json.url post_url(post, format: :json)
json.comments post.comments do |comment|
	json.text comment.text
  	json.user comment.user
end