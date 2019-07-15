# frozen_string_literal: true

require 'test_helper'

class GamesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @game = games(:one)
  end

  test 'should get index' do
    get games_url
    assert_response :success
  end

  test 'should show game' do
    get game_url(@game)
    assert_response :success
  end

  test 'should show game AMP page' do
    get game_url(@game, format: :amp)
    assert_response :success
  end
end
