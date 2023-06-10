require 'rails_helper'

RSpec.describe SleepTimeRecord, type: :model do
  describe "associations" do
    it { should belong_to(:user) }
  end

  describe "validations" do
    it { should validate_presence_of(:clock_in) }
    it { should validate_presence_of(:clock_out) }
  end
end
