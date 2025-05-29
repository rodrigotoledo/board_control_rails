69.times do
  30.times do |i|
    Task.create!(
      title: Faker::Lorem.question,
      scheduled_at: Time.now + rand(1..30).days
    )

    Task.create!(
      title: Faker::Lorem.question,
      scheduled_at: rand(1..30).days.ago,
      completed_at: rand(1..30).days.ago
    )

    Project.create!(
      name: Faker::Job.title,
      created_at: rand(1..365).days.ago
    )

    if i % 3 == 0
      Project.create!(
        name: Faker::Job.title,
        completed_at: rand(1..30).days.ago,
        created_at: rand(31..365).days.ago
      )
    else
      Project.create!(
        name: Faker::Job.title
      )
    end
  end
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
