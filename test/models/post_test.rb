# frozen_string_literal: true

require 'test_helper'

class PostTest < ActiveSupport::TestCase
  setup do
    @game = games(:one)
    @user = users(:one)
    @post = posts(:one)
    @hashtag_post = posts(:hashtag)
    @nice = relations(:nice)
  end

  test 'name' do
    assert @post.name == @user.display_name + "'s check-in to " + @game.title
  end

  test 'nices' do
    assert @post.nices.include?(@nice)
    assert @post.nices.size == 1
    @post.destroy_associated
    assert @user.relations.where(relationship: 'nice').empty?
  end

  test 'url' do
    assert @post.url == Rails.application.config.app_domain + '/check-ins/' + @post.id.to_s
  end

  test 'search' do
    assert Post.search('hashtag').include?(@hashtag_post)
    assert !Post.search('hashtag').include?(@post)
  end
end
