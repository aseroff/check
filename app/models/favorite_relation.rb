class FavoriteRelation < Relation
	
  def related_item
    Game.find(related_id)
  end
end