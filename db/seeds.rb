30.times do |i|
  Task.create!(title: Faker::Lorem.question, scheduled_at: (Time.now+ 1.days))
  Project.create!(name: Faker::Job.title)
end