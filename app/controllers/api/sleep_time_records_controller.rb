class Api::SleepTimeRecordsController < ApplicationController
  def index
    sleep_records = @current_user.sleep_time_records
    .select(
      "*, EXTRACT(EPOCH FROM (clock_out - clock_in)) / 60 as duration_minutes"
    ).order("created_at DESC")

    if sleep_records.present?
      render_data(sleep_records, "Sleep record list")
    else
      render_empty_data
    end
  end

  def friends
    friends = @current_user.followings
    sleep_records = SleepTimeRecord.where(user: friends).where("created_at > ?", 1.week.ago)
      .select("*, EXTRACT(EPOCH FROM (clock_out - clock_in)) / 60 as duration_minutes")
      .order("duration_minutes DESC")
    if sleep_records.present?
      render_data(sleep_records, "Followed sleep record list")
    else
      render_empty_data
    end
  end

  def create
    sleep_record = @current_user.sleep_time_records.new(sleep_record_params)
    if sleep_record.save
      render_success("Sleep record is created", :created)
    else
      render_error(sleep_record.errors.full_messages, :unprocessable_entity)
    end
  end

  private

  def sleep_record_params
    params.require(:sleep_time_record).permit(:clock_in, :clock_out)
  end
end
