FactoryGirl.define do
  factory :organization do 
    sequence(:name) { |n| "#{Faker::Color.color_name}-#{n}" }
  end
end