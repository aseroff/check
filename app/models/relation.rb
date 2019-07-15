# frozen_string_literal: true

class Relation < ApplicationRecord
  validate :user_id, :relationship, :related_id
  belongs_to :user
  validates_uniqueness_of :user_id, scope: %i[related_id relationship]

  def related_item
    if relationship == 'follow'
      related = User.find(related_id)
    elsif relationship == 'nice' || relationship == 'mention' || relationship == 'comment'
      related = Post.find(related_id)
    else
      related = Game.find(related_id)
    end
    related
  end

  def self.relation_types
    %w[follow favorite owns nice mention comment]
  end
end
