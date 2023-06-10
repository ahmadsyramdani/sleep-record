require 'rails_helper'

RSpec.describe Api::SleepTimeRecordsController, type: :controller do
  let(:current_user) { User.create(name: 'Jane', email: 'jane@email.com', password: 'password') }
  let(:sleep_record1) {
    SleepTimeRecord.create(
      clock_in: 2.days.ago.beginning_of_day + 19.hours.ago,
      clock_out: 2.days.ago.beginning_of_day + 1.day + 5.hours.ago,
      user: current_user
    )
  }
  let(:sleep_record2) {
    SleepTimeRecord.create(
      clock_in: 1.day.ago.beginning_of_day + 19.hours.ago,
      clock_out: 1.day.ago.beginning_of_day + 1.day + 6.hours.ago,
      user: current_user
    )
  }

  before do
    current_user.generate_api_key
    @request.headers['Authorization'] = "Bearer #{current_user.api_key}"
  end

  describe "GET index" do
    it "returns a list of sleep records for the current user" do
      SleepTimeRecord.create(
        clock_in: 4.days.ago.beginning_of_day + 19.hours,
        clock_out: 3.days.ago.beginning_of_day + 3.hours.ago,
        user: current_user
      )
      SleepTimeRecord.create(
        clock_in: 3.days.ago.beginning_of_day + 19.hours,
        clock_out: 2.days.ago.beginning_of_day + 5.hours.ago,
        user: current_user
      )

      get :index

      expect(response).to have_http_status(:ok)
      expect(json_response["message"]).to eq("Sleep record list")
      expect(json_response["data"].length).to eq(2)
    end
  end

  describe "GET friends" do
    it "returns a list of sleep records for the user's friends" do
      friend1 = User.create(name: 'friend1', email: 'friend1@email.com', password: 'password')
      friend2 = User.create(name: 'friend2', email: 'friend2@email.com', password: 'password')
      SleepTimeRecord.create(
        clock_in: 4.days.ago.beginning_of_day + 19.hours,
        clock_out: 3.days.ago.beginning_of_day + 3.hours.ago,
        user: friend1
      )
      SleepTimeRecord.create(
        clock_in: 3.days.ago.beginning_of_day + 19.hours,
        clock_out: 2.days.ago.beginning_of_day + 5.hours.ago,
        user: friend2
      )

      current_user.followings << friend1
      current_user.followings << friend2

      get :friends

      expect(response).to have_http_status(:ok)
      expect(json_response["message"]).to eq("Followed sleep record list")
      expect(json_response["data"].length).to eq(2)
    end
  end

  describe "POST create" do
    it "creates a new sleep record for the current user" do
      post :create, params: { sleep_time_record: { clock_in: Time.now, clock_out: Time.now + 8.hours } }

      expect(response).to have_http_status(:created)
      expect(json_response["message"]).to eq("Sleep record is created")
    end

    it "returns an error when creating a sleep record with invalid parameters" do
      post :create, params: { sleep_time_record: { clock_in: nil, clock_out: nil } }

      expect(response).to have_http_status(:unprocessable_entity)
      expect(json_response["message"]).to eq(["Clock in can't be blank", "Clock out can't be blank"])
    end
  end

  def json_response
    JSON.parse(response.body)
  end
end
