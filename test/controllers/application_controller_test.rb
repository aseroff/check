require 'test_helper'

class ApplicationControllerTest < ActionDispatch::IntegrationTest

  test "should get about" do
    get about_url
    assert_response :success
  end

  test "should get cookies" do
    get cookies_url
    assert_response :success
  end

  test "should get privacy" do
    get privacy_url
    assert_response :success
  end

  test "should get terms" do
    get terms_url
    assert_response :success
  end
  
  test "should get investors" do
    get investors_url
    assert_response :success
  end
end
