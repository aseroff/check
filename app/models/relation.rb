# frozen_string_literal: true

# Relation object
class Relation < ApplicationRecord
  validate :user_id, :relationship, :related_id
  belongs_to :user
  validates :user_id, uniqueness: { scope: %i[related_id relationship] }

  def related_item
    related = if relationship == 'follow'
                User.find(related_id)
              elsif relationship == 'nice' || relationship == 'mention' || relationship == 'comment'
                Post.find(related_id)
              else
                Game.find(related_id)
              end
    related
  end

  def self.relation_types
    %w[follow favorite owns nice mention comment]
  end
end
