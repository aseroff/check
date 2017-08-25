class User < ApplicationRecord
  extend FriendlyId
  friendly_id :username, use: :slugged
  mount_uploader :avatar, AvatarUploader
  validates_integrity_of  :avatar
  validates_processing_of :avatar
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable
  has_many :posts, :dependent => :destroy
  has_many :relations, :dependent => :destroy
  validates :username, uniqueness: true
  validates :email, uniqueness: true
  scope :for_ids_with_order, ->(ids) {
    order = sanitize_sql_array(
      ["position(id::text in ?)", ids.join(',')]
    )
    where(:id => ids).order(order)
  } 

  has_many :authorizations, :dependent => :destroy

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
    #  user.email = auth.info.email
    #  user.password = Devise.friendly_token[0,20]
    #  user.username = auth.info.email
    # If you are using confirmable and the provider(s) you use validate emails, 
    # uncomment the line below to skip the confirmation emails.
    # user.skip_confirmation!
    end
  end

  def tweet(post, token, secret)
    if self.provider == "twitter" && self.uid
      client = Twitter::REST::Client.new do |config|
        config.consumer_key        = "dFPIQW8rTerq2ncKA90NJt8ty"
        config.consumer_secret     = "Pxg5whATp65Wydc474JtyJ6IDpsw0KgGlR5BNmbT4sbd2RTiVg"
        config.access_token        = token
        config.access_token_secret = secret
      end
      if post.text.empty?
        message = "I checked in to #{post.game.title} on GameKeeper! " + post.url
      else
        message = (post.text.length > 112 ? post.text[0..112] + "... " : " ") +  post.url
      end
      resp = client.update(message)
    end
    resp.id
  end

  def display_name
    '@' + self.username.to_s
  end

  def following
  	Relation.where(user_id: self.id, relationship: "follow").order(created_at: :desc)
  end

  def following_users
    User.where("id in (?)", self.following.pluck(:related_id))
  end

  def followers
  	Relation.where(related_id: self.id, relationship: "follow").order(created_at: :desc)
  end

  def follower_users
    User.where("id in (?)", self.followers.pluck(:user_id))
  end

  def favorites
    self.relations.where(relationship: "favorite").order(created_at: :desc)
  end

  def favorite_games
  	Game.where("id in (?)", self.relations.where(relationship: "favorite").collect {|r| r.related_id})
  end

  def owned
    self.relations.where(relationship: "owns").order(created_at: :desc)
  end

  def owned_games
  	Game.where("id in (?)", self.relations.where(relationship: "owns").collect {|r| r.related_id})
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
  	!self.relations.where(relationship: "owns", related_id: game_id).empty?
  end

  def has_connection_with(provider)
      auth = self.authorizations.where(provider: provider).first
      if auth.present?
          auth.token.present?
      else
          false
      end
  end

  def popular_with_friends
    h = Post.where("created_at > ? and user_id IN (?)", (DateTime.now - 2.weeks), self.following.pluck(:related_id)).group(:game_id).order('count_id DESC').count(:id)
    h.to_a[0..(h.size > 5 ? 5 : h.size)] 
  end

  private
    def avatar_size_validation
      errors[:avatar] << "should be less than 500KB" if avatar.size > 0.5.megabytes
    end
end
