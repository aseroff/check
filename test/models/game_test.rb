require 'test_helper'

class GameTest < ActiveSupport::TestCase
	
  setup do
    @game = games(:one)
    @user = users(:one)
    @user2 = users(:two)
    @post = posts(:one)
    @owned_relation = relations(:owned)
    @favorite_relation = relations(:favorite)
  end

  test "favorites" do
    assert @game.favorites.include?(@favorite_relation)
    assert @game.favorites.size == 1
  end

  test "owned" do
    assert @game.owned.include?(@owned_relation)
    assert @game.owned.size == 1
  end

  test "search" do
    assert Game.search("string").include?(@game)
    assert Game.search("sTRIng").include?(@game)
    assert Game.search("STRING").include?(@game)
    assert Game.search("str").include?(@game)
    assert Game.search("STR").include?(@game)
    assert !Game.search("strang").include?(@game)
  end

end
