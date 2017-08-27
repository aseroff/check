class AddTwitterTokenToUser < ActiveRecord::Migration[5.1]
  def change
  	add_column :users, :twitter_token, :string
  	add_column :users, :twitter_token_secret, :string
  end
end
