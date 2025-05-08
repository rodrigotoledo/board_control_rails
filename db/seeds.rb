30.times do |_i|
  Task.create!(title: Faker::Lorem.question, scheduled_at: (Time.now + 1.days))
  Task.create!(title: Faker::Lorem.question, completed_at: Time.now, scheduled_at: 1.day.ago)
  Project.create!(name: Faker::Job.title)
  Project.create!(name: Faker::Job.title, completed_at: Time.now)
end
User.find_or_create_by(email: "example@example.com") do |user|
  user.password = "password"
  user.password_confirmation = "password"
end
User.find_or_create_by(email: "user@example.com") do |user|
  user.password = "password"
  user.password_confirmation = "password"
end
User.find_or_create_by(email: "faker@test.com") do |user|
  user.password = "password"
  user.password_confirmation = "password"
end
