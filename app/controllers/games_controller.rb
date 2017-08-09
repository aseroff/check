class GamesController < ApplicationController
  before_action :set_game, only: [:show, :edit, :update, :destroy]
  before_action :find_relations, only: [:show]
  before_action :count_stats, only: [:show]

  # GET /games
  # GET /games.json
  def index
    if params[:filter]
      @filter = params[:filter]
      ids = []
      if @filter == "popular"
        Game.popular(20).each{|k,v| ids << k}
      elsif @filter == "favorited"
        Game.favorited(20).each{|k,v| ids << k}
      elsif @filter == "owned"
        Game.owned(20).each{|k,v| ids << k}
      elsif @filter == "recent"
        Game.recently_added(20).each{|g| ids << g.id}
      end
      @games = Game.order_as_specified(id: ids)
    else
      @games = Game.search(params[:term])
    end
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
      if current_user
        @favorite_relation = Relation.find_by(user_id: current_user.id, related_id: @game.id, relationship:"favorite")
        @owned_relation = Relation.find_by(user_id: current_user.id, related_id: @game.id, relationship:"owns")
      end
    end

    def count_stats
      @posts_count = @game.posts.size
      @favorites_count = @game.favorites.size
      @owned_count = @game.owned.size
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def game_params
      params.require(:game).permit(:title, :description, :year, :img_url)
    end
end
