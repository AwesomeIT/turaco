FactoryGirl.define do 
  factory :application, class: Doorkeeper::Application do 
    name { Faker::App.name }
    redirect_uri { Faker::Internet.url }
  end
end