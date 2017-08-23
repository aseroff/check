class Post < ApplicationRecord
  	include Rails.application.routes.url_helpers
	validate :user_id, :game_id
	belongs_to :user
	belongs_to :game

	def nices
		Relation.where(relationship: "nice", related_id: self.id)
	end

	def name
		self.user.display_name + "'s check-in to " + self.game.title
	end

  	def url
    	Rails.root.to_s + post_path(self)
  	end
end
