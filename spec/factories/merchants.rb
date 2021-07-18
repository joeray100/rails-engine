FactoryBot.define do
  factory :merchant do
    sequence(:id)
    name { Faker::Company.name }
  end
end
