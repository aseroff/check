# frozen_string_literal: true

json.array! @relations, partial: 'relations/following_relation', as: :user_relation
