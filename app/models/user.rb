class User < ApplicationRecord
  has_secure_password

  has_many :follower_relationships, foreign_key: :following_id, class_name: 'Relationship', dependent: :destroy
  has_many :followers, through: :follower_relationships, source: :follower

  has_many :following_relationships, foreign_key: :follower_id, class_name: 'Relationship', dependent: :destroy
  has_many :followings, through: :following_relationships, source: :following

  validates :name, presence: true
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password_digest, presence: true

  def follow(user)
    following_relationships.create(following_id: user.id)
  end

  def unfollow(user)
    following_relationships.find_by(following_id: user.id).destroy
  end

  def follower_count
    followers.count
  end

  def following_count
    followings.count
  end

  def following?(user)
    followings.exists?(user.id)
  end

  def generate_api_key
    self.api_key = SecureRandom.hex(32)
    self.save!
  end
end
