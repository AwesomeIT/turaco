# frozen_string_literal: true
FactoryGirl.define do
  factory :role do
    sequence(:name) { |n| "#{Faker::Color.color_name}-#{n}" }
    description { Faker::Lorem.sentence }
  end
end
