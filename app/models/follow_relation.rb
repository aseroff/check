# frozen_string_literal: true

class FollowRelation < Relation
  def related_item
    User.find(related_id)
  end
end
