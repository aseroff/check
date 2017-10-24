game = game_relation.related_item
json.extract! game, :id, :title, :description, :year, :img_url, :created_at, :updated_at
json.url game_url(game, format: :json)