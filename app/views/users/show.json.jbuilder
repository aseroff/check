json.partial! "users/user", user: @user
json.posts @posts, partial: "posts/post", as: :post