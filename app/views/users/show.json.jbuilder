json.partial! "users/user", user: @user
json.array! @posts, partial: 'posts/post', as: :post