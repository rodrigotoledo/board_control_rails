FactoryBot.define do
  factory :project do
    name { Faker::Lorem.sentence }
    users { [Faker::Name.name_with_middle, Faker::Name.name_with_middle].to_sentence }
  end
end
