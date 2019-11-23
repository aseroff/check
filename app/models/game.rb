# frozen_string_literal: true

require 'httparty'

# Game object
class Game < ApplicationRecord
  extend FriendlyId
  friendly_id :title, use: :slugged
  mount_uploader :img_url, GameUploader
  validates_integrity_of  :img_url
  validates_processing_of :img_url
  has_many :posts, dependent: :destroy
  scope :for_ids_with_order, lambda { |ids|
                               order = sanitize_sql_array(
                                 ['position(id::text in ?)', ids.join(',')]
                               )
                               where(id: ids).order(order)
                             }

  def favorites
    Relation.where(related_id: id, relationship: 'favorite')
  end

  def owned
    Relation.where(related_id: id, relationship: 'owns')
  end

  def self.import(id)
    game = Game.find_by(id: id)
    if game.nil?
      resp = HTTParty.get('https://www.boardgamegeek.com/xmlapi2/thing?id=' + id.to_s + '&type=boardgame')
      resp = Nokogiri::XML.parse(resp.body)
      if resp.xpath('//name').first
        game = Game.new(id: id, title: resp.xpath('//name').first[:value])
        game[:description] = resp.xpath('//description').first.children.first.to_s.html_safe.gsub('&amp;#10;', ' ') if resp.xpath('//description').first
        game[:year] = resp.xpath('//yearpublished').first.attributes.first.last.value if resp.xpath('//yearpublished').first
        game.img_url = MiniMagick::Image.open(resp.xpath('//image').first.children.last.to_s) if resp.xpath('//image').first
        game.save
      end
    elsif game[:img_url].nil? || game[:img_url][-1] == '>' # probably not needed anymore
      resp = HTTParty.get('https://www.boardgamegeek.com/xmlapi2/thing?id=' + id.to_s + '&type=boardgame')
      resp = Nokogiri::XML.parse(resp.body)
      game.update_attribute(:img_url, MiniMagick::Image.open(resp.xpath('//image').first.children.last.to_s)) if resp.xpath('//image').first
    else
      game.update_attribute(:description, game.description.html_safe.gsub('&amp;#10;', ' '))
    end
    game
  end

  def self.popular(limit = 5)
    h = Post.where('created_at > ?', (DateTime.now - 2.weeks)).group(:game_id).order('count_id DESC').count(:id)
    h.size > limit ? h.to_a[0..(limit - 1)] : h.to_a
  end

  def self.favorited(limit = 5)
    h = Relation.where('relationship = ?', 'favorite').group(:related_id).order('count_id DESC').count(:id)
    h.size > limit ? h.to_a[0..(limit - 1)] : h.to_a
  end

  def self.owned(limit = 5)
    h = Relation.where('relationship = ?', 'owns').group(:related_id).order('count_id DESC').count(:id)
    h.size > limit ? h.to_a[0..(limit - 1)] : h.to_a
  end

  def self.recently_added(limit = 5)
    Game.all.order('created_at desc').pluck(:id)[0..(limit - 1)]
  end

  def self.search(term)
    if term
      Game.where('lower(title) like ?', '%' + term.downcase + '%')
    else
      Game.all
    end
  end
end
