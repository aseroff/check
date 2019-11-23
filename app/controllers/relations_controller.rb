# frozen_string_literal: true

class RelationsController < ApplicationController
  before_action :must_be_logged_in

  # POST /relations
  # POST /relations.json
  def create
    @relation = Relation.find_or_create_by(relation_params)

    if @relation.new_record?
      if @relation.relationship == 'follow'
        notice = "You're now following " + @relation.related_item.username + '!'
      elsif @relation.relationship == 'favorite'
        notice = @relation.related_item.title + ' is now in your favorites!'
      elsif @relation.relationship == 'owns'
        notice = @relation.related_item.title + ' is now on your owned shelf!'
      elsif @relation.relationship == 'nice'
        notice = 'Nice!'
      end
    end

    respond_to do |format|
      if @relation.save
        format.html { redirect_to @relation.related_item, notice: notice }
        format.json { render @relation.related_item, status: :created, location: @relation }
      else
        format.html { redirect_to :root }
        format.json { render json: @relation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /relations/1
  # DELETE /relations/1.json
  def destroy
    @relation = Relation.find(params[:id])
    @item = @relation.related_item
    if @relation.relationship == 'follow'
      notice = "You've stopped following " + @relation.related_item.username + '.'
    elsif @relation.relationship == 'favorite'
      notice = @relation.related_item.title + ' has been removed from your favorites.'
    elsif @relation.relationship == 'owns'
      notice = @relation.related_item.title + ' has been traded away.'
    elsif @relation.relationship == 'nice'
      notice = 'Eh.'
    end

    @relation.destroy
    respond_to do |format|
      format.html { redirect_to @item, notice: notice }
      format.json { head :no_content }
    end
  end

  private

  def must_be_logged_in
    redirect_to new_user_session_path, notice: 'You must be logged in to do that.' unless current_user
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def relation_params
    params.permit(:user_id, :related_id, :relationship).merge(user_id: current_user.id)
  end
end
