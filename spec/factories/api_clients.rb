FactoryGirl.define do
  factory :api_client do
    description "foo"
    user { create :user, first_name: 'foo', last_name: 'bar', email: 'foo+1@bar.com', permissions: {janitor: 'test/*'} }
  end
end
