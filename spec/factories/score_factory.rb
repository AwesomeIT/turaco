# frozen_string_literal: true
FactoryGirl.define do
  factory :score do
    user
    sample
    experiment
    rating { Faker::Number.decimal(0, 1) }
  end
end
