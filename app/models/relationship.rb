class Relationship < ApplicationRecord
  belongs_to :follower, class_name: 'User'
  belongs_to :following, class_name: 'User'

  validate :validate_self_follow

  private

  def validate_self_follow
    errors.add(:base, "Cannot follow/unfollow self") if follower_id == following_id
  end
end
