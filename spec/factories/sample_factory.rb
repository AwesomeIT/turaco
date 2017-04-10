# frozen_string_literal: true
FactoryGirl.define do
  factory :sample do
    sequence :s3_url do |x| 
      "foo/bar/#{x}"
    end
  end
end
