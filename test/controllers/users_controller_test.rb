require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
	
  setup do
    @user = users(:one)
    @user2 = users(:two)
  end

  test "should get index" do
    get users_url
    assert_response :success
  end

  test "should show user" do
    get user_url(@user)
    assert_response :success
  end

  test "should show user AMP page" do
    get user_url(@user, format: :amp)
    assert_response :success
  end

  test "should show user following AMP page" do
    get user_following_url(@user, format: :amp)
    assert_response :success
  end

  test "should show user followers AMP page" do
    get user_followers_url(@user, format: :amp)
    assert_response :success
  end

  test "should show user favorites AMP page" do
    get user_favorites_url(@user, format: :amp)
    assert_response :success
  end

  test "should show user owned AMP page" do
    get user_owned_url(@user, format: :amp)
    assert_response :success
  end



#devise

#  test "non logged in cannot destroy user" do
#    assert_difference('User.count', 0) do
#      delete user_url(@user)
#    end
#
#    assert_redirected_to posts_url
#  end
#
#  test "logged in cannot destroy other" do
#    sign_in @user
#    assert_difference('User.count', 0) do
#      delete user_url(@user2)
#    end
#
#    assert_redirected_to posts_url
#  end
#
#  test "logged in can destroy self" do
#    sign_in @user
#    assert_difference('User.count', -1) do
#      delete user_url(@user)
#    end
#
#    assert_redirected_to posts_url
#  end

end
