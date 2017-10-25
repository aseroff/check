require 'test_helper'

class ApplicationControllerTest < ActionDispatch::IntegrationTest

  test "should get about" do
    get about_url
    assert_response :success
  end

  test "should get about AMP" do
    get about_url(format: :amp)
    assert_response :success
  end

  test "should get cookies" do
    get cookies_url
    assert_response :success
  end

  test "should get cookies AMP" do
    get cookies_url(format: :amp)
    assert_response :success
  end

  test "should get privacy" do
    get privacy_url
    assert_response :success
  end

  test "should get privacy AMP" do
    get privacy_url(format: :amp)
    assert_response :success
  end

  test "should get terms" do
    get terms_url
    assert_response :success
  end

  test "should get terms AMP" do
    get terms_url(format: :amp)
    assert_response :success
  end
  
  test "should get donate" do
    get donate_url
    assert_response :success
  end

  test "should get donate AMP" do
    get donate_url(format: :amp)
    assert_response :success
  end

  test "should get stats" do
    get stats_url
    assert_response :success
  end

end
