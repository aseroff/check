require 'test_helper'

class UserTest < ActiveSupport::TestCase
	
  setup do
    @stub_params = { username: "username", email:"valid@email.com", password:"password" }
    @user = users(:one)
    @user2 = users(:two)
    @post = posts(:one)
    @game = games(:one)
    @following_relation = relations(:follow)
    @owned_relation = relations(:owned)
    @favorite_relation = relations(:favorite)
  end

  test "username regex working correctly" do
    assert User.new(@stub_params).valid?
    valid_characters = @stub_params.update(username: "uS_ERn4m3")
    assert User.new(valid_characters).valid?
    with_at_sign = @stub_params.update(username: "US1Ern@me")
    assert !User.new(with_at_sign).valid?
    with_space = @stub_params.update(username:"USEr name")
    assert !User.new(with_space).valid?
    too_many_chars = @stub_params.update(username: "usernameusernameusernameusernameuser")
    assert !User.new(too_many_chars).valid?
  end

  test "display name" do
    assert "@" + @user.username == @user.display_name
  end

  test "associations" do
    assert @user.posts.include?(@post)
  end

  test "following and followers" do
    assert @user.following.include?(@following_relation)
    assert @user.following_users.include?(@user2)
    assert @user2.followers.include?(@following_relation)
    assert @user2.follower_users.include?(@user)
    assert @user2.is_followed_by?(@user.id)
    assert @user.follows?(@user2.id)
  end

  test "owned" do
    assert @user.owned.include?(@owned_relation)
    assert @user.owned_games.include?(@game)
    assert @user.owns?(@game.id)
  end

  test "favorites" do
    assert @user.favorites.include?(@favorite_relation)
    assert @user.favorite_games.include?(@game)
    assert @user.favorited?(@game.id)
  end

  test "search" do
  	assert User.search("test").include?(@user)
    assert User.search("TEST").include?(@user)
    assert User.search("tESt").include?(@user)
    assert !User.search("rest").include?(@user)
    assert !User.search("testt").include?(@user)
  end

end
