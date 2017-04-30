FactoryGirl.define do 
  factory :app_token, class: Doorkeeper::AccessToken do 
    token { Faker::Crypto.sha1 }
    application
  end

  factory :oauth_token, class: Doorkeeper::AccessToken do 
    token { Faker::Crypto.sha1 }
    application
    resource_owner_id { FactoryGirl.create(:user).id }
  end

  factory :researcher_token, class: Doorkeeper::AccessToken do 
    token { Faker::Crypto.sha1 }
    application
    resource_owner_id { FactoryGirl.create(:researcher_user).id }
  end
end