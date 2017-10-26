class Comment < ApplicationRecord
	belongs_to :post
	belongs_to :user
	validates :text, presence: true, length: { maximum: 280, message: " may only be 280 characters long." }


	def name
		self.user.display_name + "'s comment on " + self.post.name
	end

end
