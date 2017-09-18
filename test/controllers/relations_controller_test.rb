require 'test_helper'

class RelationsControllerTest < ActionDispatch::IntegrationTest
  
  setup do
    @user = users(:one)
    @user2 = users(:two)
    @game = games(:one)
    @relation = relations(:owned)
  end

#  test "should create relation" do
#    sign_in @user
#    assert_difference('Relation.count') do
#      post relations_url, params: { relation: { related_id: @relation.related_id, relationship: @relation.relationship } }
#    end
#    assert_redirected_to @relation.related_item
#  end

  test "should destroy relation" do
    sign_in @user
    assert_difference('Relation.count', -1) do
      delete relation_url(@relation)
    end

    assert_redirected_to @relation.related_item
  end
end
