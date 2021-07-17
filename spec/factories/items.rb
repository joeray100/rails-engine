FactoryBot.define do
  factory :item do
    name { Faker::Appliance.equipment }
    description { Faker::GreekPhilosophers.quote }
    unit_price { Faker::Commerce.price }
    merchant
  end
end
