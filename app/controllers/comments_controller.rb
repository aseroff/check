class CommentsController < ApplicationController
  before_action :set_comment, only: [:edit, :update, :destroy]
  before_action :must_be_logged_in

  def edit
  end

  def create
    @comment = Comment.new(comment_params)
    refreshed_time = Time.now
    Relation.find_or_create_by(user_id: @comment.user_id, related_id: @comment.post_id, relationship: "comment").update(created_at: refreshed_time, updated_at: refreshed_time)

    respond_to do |format|
      if @comment.save
        format.html { redirect_to @comment.post, notice: 'Comment was successfully created.' }
        format.json { render :show, status: :created, location: @comment.post }
      else
        format.html { render :new }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @comment.update(comment_params)
        format.html { redirect_to @comment, notice: 'Comment was successfully updated.' }
        format.json { render :show, status: :ok, location: @comment }
      else
        format.html { render :edit }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    Relation.find_by(user_id: @comment.user_id, related_id: @comment.post_id, relationship: "comment").destroy
    @comment.destroy
    respond_to do |format|
      format.html { redirect_to comments_url, notice: 'Comment was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      @comment = Comment.find(params[:id])
    end

    def must_be_logged_in
      redirect_to new_user_session_path, notice: "You must be logged in to do that." unless current_user
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def comment_params
      params.require(:comment).permit(:user_id, :post_id, :text).merge(user_id: current_user.id)
    end
end
