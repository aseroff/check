class Comment < ApplicationRecord
	belongs_to :post
	belongs_to :user
	validates :text, presence: true, length: { maximum: 280, message: " may only be 280 characters long." }
end
