FactoryGirl.define do 
  factory :app_token, class: Doorkeeper::AccessToken do 
    token { Faker::Crypto.sha1 }
    application
  end

  factory :user_token, class: Doorkeeper::AccessToken do
    token { Faker::Crypto.sha1 }
    association :resource_owner_id, factory: :user
  end
end