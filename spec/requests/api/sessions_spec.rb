# spec/controllers/api/sessions_controller_spec.rb

require 'rails_helper'

RSpec.describe Api::SessionsController, type: :controller do
  describe 'POST #create' do
    let!(:user) { User.create(email: 'test@example.com', password: 'password') }

    context 'with valid credentials' do
      it 'generates a new API key for the user and returns success response' do
        post :create, params: { email: 'test@example.com', password: 'password' }

        user.reload

        expect(user.api_key).to be_present
        expect(response).to have_http_status(:ok)
        expect(json_response).to eq({
          'api_key' => user.api_key,
          'message' => 'Logged in successfully.'
        })
      end
    end

    context 'with invalid credentials' do
      it 'returns unauthorized response' do
        post :create, params: { email: 'test@example.com', password: 'wrong_password' }

        expect(response).to have_http_status(:unauthorized)
        expect(json_response).to eq({ 'message' => 'Invalid email or password.' })
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:user) { User.create(email: 'test@example.com', password: 'password') }

    before do
      user.generate_api_key
      @request.headers['Authorization'] = "Bearer #{user.api_key}"
      # allow(controller).to receive(:current_user).and_return(user)
    end

    it 'generates a new API key for the user and returns success response' do
      delete :destroy

      user.reload

      expect(user.api_key).to be_nil
      expect(response).to have_http_status(:ok)
      expect(json_response).to eq({ 'message' => 'Logged out successfully.' })
    end
  end

  def json_response
    JSON.parse(response.body)
  end
end
