require 'httparty'

class Game < ApplicationRecord

	has_many :posts
  	extend FriendlyId
  	friendly_id :title, use: :slugged

	def self.import(id)
		game = Game.find_by(id: id)
		unless game
			resp = HTTParty.get('https://www.boardgamegeek.com/xmlapi2/thing?id=' + id.to_s)
			resp = Nokogiri::XML.parse(resp.body)
			game = Game.create(title: (resp.xpath('//name').first[:value]),
								description: (resp.xpath('//description').first.children.first.to_s),
								year: (resp.xpath('//yearpublished').first.attributes.first.last.value),
								img_url: (resp.xpath('//image').first.children.last.to_s),
								id: id)
		end
		game
	end

	def self.search(term)
		if term
			Game.where("lower(title) like ?", "%" + term.downcase + "%")
		else
			Game.all
		end
	end
end
