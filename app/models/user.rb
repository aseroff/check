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
end
