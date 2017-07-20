class RelationsController < ApplicationController
  before_action :set_relation, only: [:update, :destroy]

  # POST /relations
  # POST /relations.json
  def create
    @relation = Relation.new(relation_params)

    respond_to do |format|
      if @relation.save
        format.html { redirect_to @relation.related_item, notice: 'Nice.' }
        format.json { render @relation.related_item, status: :created, location: @relation }
      else
        format.html { redirect_to :root }
        format.json { render json: @relation.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /relations/1
  # PATCH/PUT /relations/1.json
  def update
    respond_to do |format|
      if @relation.update(relation_params)
        format.html { redirect_to @relation, notice: 'Relation was successfully updated.' }
        format.json { render :show, status: :ok, location: @relation }
      else
        format.html { render :edit }
        format.json { render json: @relation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /relations/1
  # DELETE /relations/1.json
  def destroy
    @item = @relation.related_item
    @relation.destroy
    respond_to do |format|
      format.html { redirect_to @item, notice: 'Not anymore!' }
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
