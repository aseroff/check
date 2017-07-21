class GamesController < ApplicationController
  before_action :set_game, only: [:show, :edit, :update, :destroy]
  before_action :find_relations, only: [:show]

  # GET /games
  # GET /games.json
  def index
    @games = Game.search(params[:term])
  end

  # GET /games/1
  # GET /games/1.json
  def show
    @posts = @game.posts.order(created_at: :desc).paginate(page: params[:page], per_page: 5)
    respond_to do |format|
      format.html
      format.js
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_game
      @game = Game.friendly.find(params[:id])
    end
    def find_relations
      @favorite_relation = Relation.find_by(user_id: current_user.id, related_id: @game.id, relationship:"favorite") if current_user && current_user.favorited?(@game.id)
      @owned_relation = Relation.find_by(user_id: current_user.id, related_id: @game.id, relationship:"owns") if current_user && current_user.owns?(@game.id)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def game_params
      params.require(:game).permit(:title, :description, :year, :img_url)
    end
end
