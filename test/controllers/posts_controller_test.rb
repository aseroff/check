require 'test_helper'

class PostsControllerTest < ActionDispatch::IntegrationTest

  setup do
    @author = users(:one)
    @user2 = users(:two)
    @game = games(:one)
    @post = posts(:one)
  end

  test "no login should get index" do
    get posts_url
    assert_response :success
  end

  test "logged in should get index" do
    sign_in @author
    get posts_url
    assert_response :success
  end

  test "no login should get redirected on new" do
    get new_post_url
    assert_response :redirect
  end

  test "logged in user should get new" do
    sign_in @author
    get new_post_url(game_id: 1)
    assert_response :success
  end

  test "logged in user should create post" do
    sign_in @author
    assert_difference('Post.count') do
      post posts_url, params: { post: { game_id: @post.game_id, text: @post.text, user_id: @post.user_id } }
    end

    assert_redirected_to post_url(Post.last)
  end

  test "non logged in user should show post" do
    get post_url(@post)
    assert_response :success
  end

  test "non logged in user should show post AMP" do
    get post_url(@post, format: :amp)
    assert_response :success
  end

  test "logged in user should show post" do
    sign_in @user2
    get post_url(@post)
    assert_response :success
  end

  test "logged in user should show post AMP" do
    sign_in @user2
    get post_url(@post, format: :amp)
    assert_response :success
  end

  test "author should show post" do
    sign_in @author
    get post_url(@post)
    assert_response :success
  end

  test "arthur should show post AMP" do
    sign_in @author
    get post_url(@post, format: :amp)
    assert_response :success
  end

  test "non logged in should not get edit" do
    get edit_post_url(@post)
    assert_response :redirect
  end

  test "logged in should not get edit" do
    sign_in @user2
    get edit_post_url(@post)
    assert_response :redirect
  end

  test "author should get edit" do
    sign_in @author
    get edit_post_url(@post)
    assert_response :success
  end

  test "non logged in should not update post" do
    patch post_url(@post), params: { post: { game_id: @post.game_id, text: @post.text, user_id: @post.user_id } }
    assert_redirected_to posts_url
  end

  test "logged in should not update post" do
    sign_in @user2
    patch post_url(@post), params: { post: { game_id: @post.game_id, text: @post.text, user_id: @post.user_id } }
    assert_redirected_to posts_url
  end

  test "author should update post" do
    sign_in @author
    patch post_url(@post), params: { post: { game_id: @post.game_id, text: @post.text, user_id: @post.user_id } }
    assert_redirected_to post_url(@post)
  end

  test "non logged in should not destroy post" do
    assert_difference('Post.count', 0) do
      delete post_url(@post)
    end

    assert_redirected_to posts_url
  end

  test "logged in should not destroy post" do
    sign_in @user2
    assert_difference('Post.count', 0) do
      delete post_url(@post)
    end

    assert_redirected_to posts_url
  end

  test "author should destroy post" do
    sign_in @author
    assert_difference('Post.count', -1) do
      delete post_url(@post)
    end

    assert_redirected_to posts_url
  end
end
