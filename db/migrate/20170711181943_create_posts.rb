class CreatePosts < ActiveRecord::Migration[5.1]
  def change
    create_table :posts do |t|
      t.integer :user_id
      t.integer :game_id
      t.string :subtype

      t.timestamps
    end
  end
end
