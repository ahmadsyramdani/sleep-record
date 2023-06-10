require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it { should have_many(:follower_relationships).dependent(:destroy) }
    it { should have_many(:followers).through(:follower_relationships) }
    it { should have_many(:following_relationships).dependent(:destroy) }
    it { should have_many(:followings).through(:following_relationships) }
    it { should have_many(:sleep_time_records) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:password_digest) }
  end

  describe 'methods' do
    let(:user) { User.create(name: 'Test', email: 'test@email.com', password: 'password') }

    it 'follows a user' do
      following_user = User.create(name: 'John', email: 'john@email.com', password: 'password')
      user.follow(following_user)

      expect(user.followings).to include(following_user)
    end

    it 'unfollows a user' do
      following_user = User.create(name: 'John', email: 'john@email.com', password: 'password')
      user.follow(following_user)
      user.unfollow(following_user)

      expect(user.followings).not_to include(following_user)
    end

    it 'returns the count of followers' do
      follower1 = User.create(name: 'John 1', email: 'john1@email.com', password: 'password')
      follower2 = User.create(name: 'John 2', email: 'john2@email.com', password: 'password')
      follower1.follow(user)
      follower2.follow(user)

      expect(user.follower_count).to eq(2)
    end

    it 'returns the count of followings' do
      following1 = User.create(name: 'John 1', email: 'john1@email.com', password: 'password')
      following2 = User.create(name: 'John 2', email: 'john2@email.com', password: 'password')
      user.follow(following1)
      user.follow(following2)

      expect(user.following_count).to eq(2)
    end

    it 'checks if user is following another user' do
      following_user = User.create(name: 'John', email: 'john@email.com', password: 'password')
      user.follow(following_user)

      expect(user.following?(following_user)).to be_truthy
    end
  end

  describe '#generate_api_key' do
    let(:user) { User.create(name: 'test', email: 'test@email.com', password: 'password123') }

    it 'generates a new API key' do
      user.generate_api_key
      expect(user.api_key).not_to be_nil
    end

    it 'saves the user with the generated API key' do
      expect(user).to receive(:save!)
      user.generate_api_key
    end
  end
end
