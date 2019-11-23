# frozen_string_literal: true

# Controller for mobile application comments
class Api::CommentsController < ApplicationController
  protect_from_forgery with: :null_session
  before_action :set_comment_and_post, only: %i[update destroy]
  before_action :look_up_authenticated_user

  def create
    @comment = Comment.new(user_id: @current_user.id, post_id: params[:post_id], text: params[:text])
    refreshed_time = Time.zone.now
    Relation.find_or_create_by(user_id: @current_user.id, related_id: @comment.post_id, relationship: 'comment').update(created_at: refreshed_time, updated_at: refreshed_time)

    respond_to do |format|
      if @comment.save
        format.json { render :show, status: :created, location: @comment.post }
      else
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @comment.update(comment_params)
        format.html { redirect_to @post, notice: 'Comment was successfully updated.' }
        format.json { render :show, status: :ok, location: @comment }
      else
        format.html { render :edit }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    r = Relation.find_by(user_id: @comment.user_id, related_id: @comment.post_id, relationship: 'comment')
    r&.destroy
    @comment.destroy
    respond_to do |format|
      format.html { redirect_to @post, notice: 'Comment was successfully deleted.' }
      format.json { head :no_content }
    end
  end

  private

  def set_comment_and_post
    @comment = Comment.find(params[:id])
    @post = @comment.post
  end

  def look_up_authenticated_user
    @current_user = User.find_by(access_token: params[:access_token])
  end

  def comment_params
    params.permit(:access_token, :post_id, :text).merge(user_id: @current_user.id)
  end
end
