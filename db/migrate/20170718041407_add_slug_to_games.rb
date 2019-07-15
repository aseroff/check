# frozen_string_literal: true

class AddSlugToGames < ActiveRecord::Migration[5.1]
  def change
    add_column :games, :slug, :string
  end
end
