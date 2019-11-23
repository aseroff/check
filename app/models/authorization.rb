# frozen_string_literal: true

# Authorization object
class Authorization < ApplicationRecord
  belongs_to :user
end
