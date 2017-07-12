class Post < ApplicationRecord
	validate :user_id, :game_id
	belongs_to :user
	belongs_to :game

	def nice_count
		Relation.where(relationship: "nice", related_id: self.id).size
	end
end
