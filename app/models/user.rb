class User < ApplicationRecord
  mount_uploader :avatar, AvatarUploader
  validates_integrity_of  :avatar
  validates_processing_of :avatar
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

  def is_followed_by?(user_id)
    self.followers.include?(user_id)
  end

  def follows?(user_id)
    self.following.include?(user_id)
  end

  def favorited?(game_id)
  	!self.relations.where(relationship: "favorite", related_id: game_id).empty?
  end

  def owns?(game_id)
  	!self.relations.where(relationship: "owned", related_id: game_id).empty?
  end

  private
    def avatar_size_validation
      errors[:avatar] << "should be less than 500KB" if avatar.size > 0.5.megabytes
    end
end
