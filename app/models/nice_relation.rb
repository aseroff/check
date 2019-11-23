class NiceRelation < Relation
	
  def related_item
    Post.find(related_id)
  end
end