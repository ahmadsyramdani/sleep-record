require 'rails_helper'

RSpec.describe Relationship, type: :model do
  describe 'validations' do
    it 'does not allow self-following' do
      user = User.create(name: 'test', email: 'test@email.com', password: 'password')
      relationship = Relationship.new(follower: user, following: user)

      expect(relationship).not_to be_valid
      expect(relationship.errors[:base]).to include("Cannot follow/unfollow self")
    end

    it 'allows following different users' do
      user1 = User.create(name: 'test1', email: 'test1@email.com', password: 'password')
      user2 = User.create(name: 'test2', email: 'test2@email.com', password: 'password')
      relationship = Relationship.new(follower: user1, following: user2)

      expect(relationship).to be_valid
    end
  end
end
