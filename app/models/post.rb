class Post < ApplicationRecord
	validate :user_id, :game_id
	belongs_to :user
	belongs_to :game
	has_many :comments

	def nices
		Relation.where(relationship: "nice", related_id: self.id)
	end

	def name
		self.user.display_name + "'s check-in to " + self.game.title
	end

  	def url
    	Rails.application.config.app_domain + '/check-ins/' + self.id.to_s
  	end

  	def destroy_associated
  		Relation.where(related_id: self.id, relationship: "nice").delete_all
  		Relation.where(related_id: self.id, relationship: "mention").delete_all
  	end

	def self.search(term)
		if term
			Post.where("lower(text) like ?", "%" + term.downcase + "%")
		else
			Post.all
		end
	end

end
