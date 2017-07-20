class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_action :must_be_logged_in, only: [:new, :edit, :update, :destroy]

  # GET /posts
  # GET /posts.json
  def index
    @posts = Post.where("user_id IN (?)", (current_user.following_users + [current_user])).order(created_at: :desc) if current_user
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
    @relation = Relation.find_by(user_id: current_user.id, related_id: self.id, relationship: "nice")
  end

  # GET /posts/new
  def new
    @game = Game.find(params[:game_id]) if params[:game_id]
    @post = Post.new(user_id: current_user.id, game_id: params[:game_id])
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts
  # POST /posts.json
  def create
    @post = Post.new(post_params)

    respond_to do |format|
      if @post.save
        format.html { redirect_to @post, notice: 'Post was successfully created.' }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to @post, notice: 'Post was successfully updated.' }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post.destroy
    respond_to do |format|
      format.html { redirect_to posts_url, notice: 'Post was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def post_params
      params.require(:post).permit(:user_id, :game_id, :text)
    end

    def must_be_logged_in
      redirect_to :root, notice: "Must be logged in to check in!" unless current_user
    end
end
