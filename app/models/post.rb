# frozen_string_literal: true

# Post object
class Post < ApplicationRecord
  validate :user_id, :game_id
  belongs_to :user
  belongs_to :game
  has_many :comments, dependent: :destroy
  # has_many :nice_relations, dependent: :destroy
  # has_many :mention_relations, dependent: :destroy

  def nices
    Relation.where(relationship: 'nice', related_id: id)
  end

  def name
    user.display_name + "'s check-in to " + game.title
  end

  def url
    Rails.application.config.app_domain + '/check-ins/' + id.to_s
  end

  def destroy_associated
    Relation.where(related_id: id, relationship: 'nice').delete_all
    Relation.where(related_id: id, relationship: 'mention').delete_all
  end

  def self.search(term)
    term ? Post.where('lower(text) like ?', '%' + term.downcase + '%') : Post.all
  end
end
