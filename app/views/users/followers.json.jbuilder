# frozen_string_literal: true

json.array! @relations, partial: 'relations/followers_relation', as: :user_relation, locals: { followers: true }
