# frozen_string_literal: true
FactoryGirl.define do
  factory :sample do
    sequence :s3_url { |x| "foo/bar/#{x}" }
  end
end
