FactoryGirl.define do
  factory :api_client do
    description "foo"
    user { create :user }
  end
end
