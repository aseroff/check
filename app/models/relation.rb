class Relation < ApplicationRecord
	validate :user_id, :relationship, :related_id
	belongs_to :user

	def self.relation_types
		["follow", "favorite", "wishlist", "owned", "nice"]
	end
end
