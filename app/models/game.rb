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
		unless game
			resp = HTTParty.get('https://www.boardgamegeek.com/xmlapi2/thing?id=' + id.to_s)
			resp = Nokogiri::XML.parse(resp.body)
			game = Game.new(title: (resp.xpath('//name').first[:value]),
								description: (resp.xpath('//description').first.children.first.to_s.gsub('&amp;#10;&amp;#10;', ' ') if resp.xpath('//description').first),
								year: (resp.xpath('//yearpublished').first.attributes.first.last.value if resp.xpath('//yearpublished').first),
								img_url: (MiniMagick::Image.open(resp.xpath('//image').first.children.last.to_s if resp.xpath('//image').first),
								id: id)
		else
			game.update_attribute(:description, game.description.gsub('&amp;#10;&amp;#10;', ' ')) 
		end
		game.save
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
