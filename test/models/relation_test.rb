require 'test_helper'

class RelationTest < ActiveSupport::TestCase

  setup do
    @game = games(:one)
    @user = users(:one)
    @user2 = users(:two)
    @post = posts(:one)
    @mention_post = posts(:mention)
    @owned_relation = relations(:owned)
    @favorite_relation = relations(:favorite)
    @nice_relation = relations(:nice)
    @follow_relation = relations(:follow)
    @mention_relation = relations(:mention)
  end

  test "follow" do
    assert Relation.relation_types.include?(@follow_relation.relationship)
    assert @follow_relation.related_item == @user2
  end

  test "nice" do
    assert Relation.relation_types.include?(@nice_relation.relationship)
    assert @nice_relation.related_item == @post
  end

  test "mention" do
    assert Relation.relation_types.include?(@mention_relation.relationship)
    assert @mention_relation.related_item == @mention_post
  end

  test "owned/favorited" do
    assert Relation.relation_types.include?(@owned_relation.relationship)
    assert @owned_relation.related_item == @game
    assert Relation.relation_types.include?(@favorite_relation.relationship)
    assert @favorite_relation.related_item == @game
  end
end
