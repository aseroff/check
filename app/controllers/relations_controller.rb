class RelationsController < ApplicationController
  before_action :set_relation, only: [:destroy]

  # POST /relations
  # POST /relations.json
  def create
    @relation = Relation.new(relation_params)

    if @relation.relationship == "follow"
      notice = "You're now following " + @relation.related_item.username + "!"
    elsif @relation.relationship == "favorite"
      notice = @relation.related_item.title + " is in your favorites!"
    elsif @relation.relationship == "owned"
      notice = @relation.related_item.title + " is on your owned shelf!"
    elsif @relation.relationship == "nice"
      notice = "Nice."
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
    @item = @relation.related_item
    if @relation.relationship == "follow"
      notice = "You've stopped following " + @relation.related_item.username + "."
    elsif @relation.relationship == "favorite"
      notice = @relation.related_item.title + " has been removed from your favorites."
    elsif @relation.relationship == "owned"
      notice = @relation.related_item.title + " has been traded away."
    elsif @relation.relationship == "nice"
      notice = "Eh."
    end  

    @relation.destroy
    respond_to do |format|
      format.html { redirect_to @item, notice: notice }
      format.json { head :no_content }
    end

  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_relation
      @relation = Relation.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def relation_params
      params.permit(:user_id, :related_id, :relationship)
    end
end
