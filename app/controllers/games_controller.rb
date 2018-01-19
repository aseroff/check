class GamesController < ApplicationController
  before_action :set_game, only: [:show, :edit, :update, :destroy]
  before_action :find_relations, only: [:show]
  before_action :count_stats, only: [:show]

  # GET /games
  # GET /games.json
  def index
    if params[:term]
      @games = Game.search(params[:term]).paginate(page: params[:page], per_page: 10) 
    elsif params[:filter]
      @filter = params[:filter]
      ids = []
      if @filter == "popular"
        Game.popular(25).each{|k,v| ids << k}
      elsif @filter == "favorited"
        Game.favorited(25).each{|k,v| ids << k}
      elsif @filter == "owned"
        Game.owned(25).each{|k,v| ids << k}
      elsif @filter == "recent"
        Game.recently_added(25).each{|g| ids << g}
      elsif @filter == "import"
        Game.none
      end
      @games = Game.for_ids_with_order(ids).paginate(page: params[:page], per_page: 10) 
    else
      ids = []
      Game.popular(25).each{|k,v| ids << k}
      @games = Game.for_ids_with_order(ids).paginate(page: params[:page], per_page: 10) 
    end


    respond_to do |format|
      format.html
      format.json.array! @games, partial: "game.json"
      format.js
    end
  end

  # GET /games/1
  # GET /games/1.json
  def show
    @posts = @game.posts.order(created_at: :desc).paginate(page: params[:page], per_page: 5)
    respond_to do |format|
      format.html
      format.amp
      format.json.partial! "game.json", as: @game
      format.js
    end
  end

  def import
    @game = Game.import(params[:id]) if params[:id]
    if @game
      redirect_to @game 
    else 
      redirect_to games_path(filter: "import"), notice: "Game is invalid (support for expansions coming soon!)" 
    end
  end


  private
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
