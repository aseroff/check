# frozen_string_literal: true

class AddIndexes < ActiveRecord::Migration[5.1]
  def change
    add_index :relations, :user_id
    add_index :relations, :relationship
    add_index :relations, :related_id
    add_index :posts, :user_id
    add_index :posts, :game_id
  end
end
