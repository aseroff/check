class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :posts
  has_many :relations

  def following
  	Relation.where(user_id: self.id, relationship: "follow").collect {|r| r.related_id}
  end

  def followers
  	Relation.where(related_id: self.id, relationship: "follow").collect {|r| r.user_id}
  end

  def favorites
  	Game.where("id in (?)", self.relations.where(relationship: "favorite").collect {|r| r.related_id})
  end

  def owned
  	Game.where("id in (?)", self.relations.where(relationship: "owned").collect {|r| r.related_id})
  end

  def favorited?(game_id)
  	!self.relations.where(relationship: "favorite", related_id: game_id).empty?
  end

  def owns?(game_id)
  	!self.relations.where(relationship: "owned", related_id: game_id).empty?
  end
  
end
