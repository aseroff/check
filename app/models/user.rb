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
  extend FriendlyId
  friendly_id :username, use: :slugged
  validates :username, uniqueness: true
  validates :email, uniqueness: true

  def display_name
    '@' + self.username.to_s
  end

  def following
  	Relation.where(user_id: self.id, relationship: "follow")
  end

  def following_users
    self.following.map {|f| User.find(f.related_id) }
  end

  def followers
  	Relation.where(related_id: self.id, relationship: "follow")
  end

  def follower_users
    self.followers.map {|f| User.find(f.user_id) }
  end

  def favorites
  	Game.where("id in (?)", self.relations.where(relationship: "favorite").collect {|r| r.related_id})
  end

  def owned
  	Game.where("id in (?)", self.relations.where(relationship: "owned").collect {|r| r.related_id})
  end

  def is_followed_by?(user_id)
    !Relation.where(user_id: user_id, related_id: self.id, relationship:"follow").empty?
  end

  def follows?(user_id)
    !Relation.where(user_id: self.id, related_id: user_id, relationship:"follow").empty?
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
