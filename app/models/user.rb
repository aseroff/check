class User < ApplicationRecord
  extend FriendlyId
  friendly_id :username, use: :slugged
  mount_uploader :avatar, AvatarUploader
  validates_integrity_of  :avatar
  validates_processing_of :avatar
  validates_size_of :avatar, maximum: 1.megabytes, message: "should be less than 1MB"
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable
  has_many :posts, :dependent => :destroy
  has_many :relations, :dependent => :destroy
  validates :username, uniqueness: true, length: { maximum: 20, message: " may only be 20 characters long." }, format: { with: /\A[a-zA-Z0-9]+\Z/, message: " may only include letters, numbers and underscores."}
  validates :email, uniqueness: true

  scope :for_ids_with_order, ->(ids) {
    order = sanitize_sql_array(
      ["position(id::text in ?)", ids.join(',')]
    )
    where(:id => ids).order(order)
  } 

  has_many :authorizations, :dependent => :destroy

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

  def notifications
    notifications = []
    Relation.where("related_id = ? and relationship = ? and created_at = updated_at", self.id, "follow").pluck(:id).each {|i| notifications << i}
    Relation.where("related_id in (?) and relationship = ? and created_at = updated_at", self.posts.pluck(:id), "nice").pluck(:id).each {|i| notifications << i}
    Relation.where("user_id = ? and relationship = ? and created_at = updated_at", self.id, "mention").pluck(:id).each {|i| notifications << i}
    Relation.where("id in (?)", notifications).order(created_at: :desc)
  end

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

  def twitter_client
    Twitter::REST::Client.new do |config|
      config.consumer_key        = ENV["TWITTER_CONSUMER_KEY"]
      config.consumer_secret     = ENV["TWITTER_CONSUMER_SECRET"]
      config.access_token        = self.twitter_token
      config.access_token_secret = self.twitter_token_secret
    end
  end

  def tweet(post)
    if self.provider == "twitter" && self.twitter_token && self.twitter_token_secret
      client = self.twitter_client
      id = client.update("I checked in to " + post.game.title + " on " + Rails.application.config.app_name + "! " + post.url).id
    end
    id.to_i if id
  end

  def friends_from_twitter
    if self.provider == "twitter" && self.twitter_token && self.twitter_token_secret
      client = self.twitter_client
      twitter_friends = client.friend_ids
      friends = User.where("uid in (?)", twitter_friends.to_h.first.last.map{|x| x.to_s})
    else 
      friends = User.none
    end
    friends
  end
  
  def self.search(term)
    if term
      User.where("lower(username) like ?", "%" + term.downcase + "%")
    else
      User.none
    end
  end

  private
    def avatar_size_validation
      errors[:avatar] << "should be less than 1MB" if avatar.size > 1.megabytes
    end

    def should_generate_new_friendly_id?
      slug.blank? || username_changed?
    end
end
