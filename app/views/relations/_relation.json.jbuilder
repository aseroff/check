json.extract! relation, :id, :user_id, :related_id, :relationship, :created_at, :updated_at
json.url relation_url(relation, format: :json)
