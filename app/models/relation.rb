class Relation < ApplicationRecord
	validate :user_id, :relationship, :related_id
	belongs_to :user
	validates_uniqueness_of :user_id, :scope => [:related_id, :relationship]

	def related_item
		if self.relationship == "follow"
			related = User.find(self.related_id)
		elsif self.relationship == "nice" || self.relationship == "mention" || self.relationship == "comment"
			related = Post.find(self.related_id)
		else
			related = Game.find(self.related_id)
		end
		related
	end

	def self.relation_types
		["follow", "favorite", "owns", "nice", "mention", "comment"]
	end
end
