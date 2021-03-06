# frozen_string_literal: true

# User object
class User < ApplicationRecord
  extend FriendlyId
  friendly_id :username, use: :slugged
  mount_uploader :avatar, AvatarUploader
  validates_integrity_of  :avatar
  validates_processing_of :avatar
  validates :avatar, file_size: { less_than: 1.megabyte, message: 'should be less than 1MB' }
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :relations, dependent: :destroy
  validates :username, uniqueness: true, length: { maximum: 20, message: ' may only be 20 characters long.' }, format: { with: /\A[a-zA-Z0-9_]+\Z/, message: ' may only include letters, numbers and underscores.' }
  validates :email, uniqueness: true

  scope :for_ids_with_order, lambda { |ids|
    order = sanitize_sql_array(
      ['position(id::text in ?)', ids.join(',')]
    )
    where(id: ids).order(order)
  }

  has_many :authorizations, dependent: :destroy

  def display_name
    '@' + username.to_s
  end

  def following
    Relation.where(user_id: id, relationship: 'follow').order(created_at: :desc)
  end

  def following_users
    User.where('id in (?)', following.pluck(:related_id))
  end

  def followers
    Relation.where(related_id: id, relationship: 'follow').order(created_at: :desc)
  end

  def follower_users
    User.where('id in (?)', followers.pluck(:user_id))
  end

  def favorites
    relations.where(relationship: 'favorite').order(created_at: :desc)
  end

  def favorite_games
    Game.where('id in (?)', relations.where(relationship: 'favorite').collect(&:related_id))
  end

  def owned
    relations.where(relationship: 'owns').order(created_at: :desc)
  end

  def owned_games
    Game.where('id in (?)', relations.where(relationship: 'owns').collect(&:related_id))
  end

  def followed_by?(user_id)
    !Relation.where(user_id: user_id, related_id: id, relationship: 'follow').empty?
  end

  def follows?(user_id)
    !Relation.where(user_id: id, related_id: user_id, relationship: 'follow').empty?
  end

  def favorited?(game_id)
    !relations.where(relationship: 'favorite', related_id: game_id).empty?
  end

  def owns?(game_id)
    !relations.where(relationship: 'owns', related_id: game_id).empty?
  end

  def connection_with?(provider)
    auth = authorizations.find_by(provider: provider)
    if auth.present?
      auth.token.present?
    else
      false
    end
  end

  def popular_with_friends
    h = Post.where('created_at > ? and user_id IN (?)', (DateTime.now - 2.weeks), following.pluck(:related_id)).group(:game_id).order('count_id DESC').count(:id)
    h.to_a[0..(h.size > 5 ? 5 : h.size)]
  end

  def notifications
    posts = self.posts.pluck(:id)
    notifications = []
    Relation.where('related_id = ? and relationship = ? and created_at = updated_at', id, 'follow').pluck(:id).each { |i| notifications << i }
    Relation.where('related_id in (?) and relationship = ? and created_at = updated_at', posts, 'nice').pluck(:id).each { |i| notifications << i }
    Relation.where('user_id = ? and relationship = ? and created_at = updated_at', id, 'mention').pluck(:id).each { |i| notifications << i }
    Relation.where('related_id in (?) and relationship = ? and created_at = updated_at', posts, 'comment').pluck(:id).each { |i| notifications << i }
    Relation.where('id in (?)', notifications).order(created_at: :desc)
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
      config.consumer_key        = ENV['TWITTER_CONSUMER_KEY']
      config.consumer_secret     = ENV['TWITTER_CONSUMER_SECRET']
      config.access_token        = twitter_token
      config.access_token_secret = twitter_token_secret
    end
  end

  def tweet(post)
    if provider == 'twitter' && twitter_token && twitter_token_secret
      client = twitter_client
      id = client.update('I checked in to ' + post.game.title + ' on ' + Rails.application.config.app_name + '! ' + post.url).id
    end
    id&.to_i
  end

  def friends_from_twitter
    if provider == 'twitter' && twitter_token && twitter_token_secret
      client = twitter_client
      twitter_friends = client.friend_ids
      friends = User.where('uid in (?)', twitter_friends.to_h.first.last.map(&:to_s))
    else
      friends = User.none
    end
    friends
  end

  def self.search(term)
    term ? User.where('lower(username) like ?', '%' + term.downcase + '%') : User.none
  end

  private

  def avatar_size_validation
    errors[:avatar] << ' should be less than 1MB' if avatar.size > 1.megabytes
  end

  def should_generate_new_friendly_id?
    slug.blank? || username_changed?
  end
end
