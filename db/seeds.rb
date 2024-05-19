30.times do |i|
  Task.create!(title: Faker::Lorem.question, scheduled_at: (Time.now+ 1.days))
  Project.create!(name: Faker::Job.title)
end
User.create!(email: 'example@example.com', password: 'password', password_confirmation: 'password')
User.create!(email: 'user@example.com', password: 'password', password_confirmation: 'password')
