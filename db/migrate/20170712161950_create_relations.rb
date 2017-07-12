class CreateRelations < ActiveRecord::Migration[5.1]
  def change
    create_table :relations do |t|
      t.integer :user_id
      t.integer :related_id
      t.string :relationship

      t.timestamps
    end
  end
end
