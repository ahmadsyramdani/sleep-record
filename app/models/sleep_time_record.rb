class SleepTimeRecord < ApplicationRecord
  belongs_to :user

  validates :clock_in, presence: true
  validates :clock_out, presence: true
end
