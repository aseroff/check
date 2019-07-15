# frozen_string_literal: true

class CreateGames < ActiveRecord::Migration[5.1]
  def change
    create_table :games do |t|
      t.string :title
      t.text :description
      t.integer :year
      t.string :img_url

      t.timestamps
    end
  end
end
