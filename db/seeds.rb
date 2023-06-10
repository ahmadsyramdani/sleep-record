# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

10.times do |n|
  User.create(
    name: "User #{n+1}",
    email: "user#{n+1}@test.com",
    password: 'password'
  )
end

users = User.all
start_date = 2.weeks.ago.to_date
end_date = Date.today

users.each do |user|
  (start_date..end_date).each do |date|
    clock_in_time = date.beginning_of_day.change(hour: rand(19..23))
    clock_out_time = clock_in_time + rand(5..10).hours

    user.sleep_time_records.create!(
      clock_in: clock_in_time,
      clock_out: clock_out_time
    )
  end
end
