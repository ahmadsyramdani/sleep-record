require 'rails_helper'

RSpec.describe Api::UsersController, type: :controller do
  let(:user) { User.create(name: 'John', email: 'john@email.com', password: 'password') }
  let(:current_user) { User.create(name: 'Jane', email: 'jane@email.com', password: 'password') }

  before do
    current_user.generate_api_key
    @request.headers['Authorization'] = "Bearer #{current_user.api_key}"
  end

  describe 'GET #index' do
    it 'returns a success response' do
      get :index
      expect(response).to have_http_status(:ok)
    end

    it 'renders the user list' do
      get :index
      expect(JSON.parse(response.body)['message']).to eq('User list')
      expect(JSON.parse(response.body)['data']).to be_an(Array)
    end
  end

  describe 'GET #show' do
    it 'returns a success response' do
      get :show, params: { id: user.id }
      expect(response).to have_http_status(:ok)
    end

    it 'renders the user profile' do
      get :show, params: { id: user.id }
      expect(JSON.parse(response.body)['message']).to eq("#{user.name} profile")
      expect(JSON.parse(response.body)['data']).to be_a(Hash)
    end
  end

  describe 'GET #following' do
    it 'returns a success response' do
      get :following, params: { id: user.id }
      expect(response).to have_http_status(:ok)
    end

    it 'renders the following list' do
      get :following, params: { id: user.id }
      expect(JSON.parse(response.body)['message']).to eq('Following list')
      expect(JSON.parse(response.body)['data']).to be_an(Array)
    end
  end

  describe 'GET #follower' do
    it 'returns a success response' do
      get :follower, params: { id: user.id }
      expect(response).to have_http_status(:ok)
    end

    it 'renders the follower list' do
      get :follower, params: { id: user.id }
      expect(JSON.parse(response.body)['message']).to eq('Follower list')
      expect(JSON.parse(response.body)['data']).to be_an(Array)
    end
  end

  describe 'POST #follow' do
    it 'follows a user' do
      post :follow, params: { id: user.id }
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['message']).to eq("You are now following #{user.name}")
    end

    it 'returns an error if already following' do
      current_user.follow(user)
      post :follow, params: { id: user.id }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)["message"]).to eq("You already follow user #{user.name}")
    end
  end

  describe 'POST #unfollow' do
    it 'unfollows a user' do
      current_user.follow(user)

      post :unfollow, params: { id: user.id }
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['message']).to eq("You have unfollowed #{user.name}")
    end

    it 'returns an error if not following' do
      post :unfollow, params: { id: user.id }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)['message']).to eq("You are not following user #{user.name}")
    end
  end
end
