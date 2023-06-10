class CreateSleepTimeRecords < ActiveRecord::Migration[6.1]
  def change
    create_table :sleep_time_records do |t|
      t.references :user, null: false, foreign_key: true
      t.datetime :clock_in
      t.datetime :clock_out

      t.timestamps
    end
  end
end
