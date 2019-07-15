# frozen_string_literal: true

json.array! @relations, partial: 'relations/game_relation', as: :game_relation
