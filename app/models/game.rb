require 'httparty'

class Game < ApplicationRecord
  	mount_uploader :img_url, GameUploader
  	validates_integrity_of  :img_url
  	validates_processing_of :img_url
	has_many :posts
  	extend FriendlyId
  	friendly_id :title, use: :slugged

	def self.import(id)
		game = Game.find_by(id: id)
		if game.nil?
			resp = HTTParty.get('https://www.boardgamegeek.com/xmlapi2/thing?id=' + id.to_s)
			resp = Nokogiri::XML.parse(resp.body)
			if resp.xpath('//name').first
				game = Game.new(id: id, title: resp.xpath('//name').first[:value])
				game[:description] = (resp.xpath('//description').first.children.first.to_s.gsub('&amp;#10;&amp;#10;', ' ')) if resp.xpath('//description').first
				game[:year] = (resp.xpath('//yearpublished').first.attributes.first.last.value) if resp.xpath('//yearpublished').first
				game[:image_url] = (MiniMagick::Image.open(resp.xpath('//image').first.children.last.to_s)) if resp.xpath('//image').first
				game.save
			end
		else
			game.update_attribute(:description, game.description.gsub('&amp;#10;&amp;#10;', ' ')) 
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

	private
    	def avatar_size_validation
    	end
end
