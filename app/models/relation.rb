class Relation < ApplicationRecord
	validate :user_id, :relationship, :related_id
	belongs_to :user
	validates_uniqueness_of :user_id, :scope => [:related_id, :relationship]

	def self.relation_types
		["follow", "favorite", "wishlist", "owned", "nice"]
	end

	def related_item
		related = nil
		if self.relationship == "follow"
			related = User.find(self.related_id)
		elsif self.relationship == "nice"
			related = Post.find(self.related_id)
		else
			related = Game.find(self.related_id)
		end
		related
	end
end
