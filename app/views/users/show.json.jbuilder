json.partial! "users/user", user: @user
json.following @following
json.followers @followers
json.posts @posts_count
json.favorited @favorited_count
json.owned @owned_count
json.posts @posts, partial: "posts/post", as: :post