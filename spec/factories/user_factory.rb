# frozen_string_literal: true
FactoryGirl.define do
  factory :user do
    email { Faker::Internet.email }
    password { Faker::Internet.password }
    roles { FactoryGirl.create_list(:role, 3) }
  end
end
