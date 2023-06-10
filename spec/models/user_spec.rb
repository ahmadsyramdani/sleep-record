require 'rails_helper'

RSpec.describe User, type: :model do
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
