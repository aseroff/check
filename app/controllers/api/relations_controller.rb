module Api
  class RelationsController < ApplicationController
    protect_from_forgery with: :null_session
    before_action :look_up_authenticated_user

    def create
      @relation = Relation.find_or_create_by(relation_params)

      if @relation.new_record?
        if @relation.relationship == "follow"
          notice = "You're now following " + @relation.related_item.username + "!"
        elsif @relation.relationship == "favorite"
          notice = @relation.related_item.title + " is now in your favorites!"
        elsif @relation.relationship == "owns"
          notice = @relation.related_item.title + " is now on your owned shelf!"
        elsif @relation.relationship == "nice"
          notice = "Nice!"
        end
      end

      respond_to do |format|
      if @relation.save
        format.json { render @relation.related_item, status: :created, location: @relation }
      else
        format.json { render json: @relation.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @relation = Relation.find(params[:id])
    @item = @relation.related_item
    if @relation.relationship == "follow"
      notice = "You've stopped following " + @relation.related_item.username + "."
    elsif @relation.relationship == "favorite"
      notice = @relation.related_item.title + " has been removed from your favorites."
    elsif @relation.relationship == "owns"
      notice = @relation.related_item.title + " has been traded away."
    elsif @relation.relationship == "nice"
      notice = "Eh."
    end  

    @relation.destroy
    respond_to do |format|
      format.json { head :no_content }
    end

  end

  private
    def look_up_authenticated_user
      @current_user = User.find_by(access_token: params[:access_token])
    end

    def relation_params
      params.permit(:user_id, :related_id, :relationship).merge(user_id: @current_user.id)
    end
  end
end