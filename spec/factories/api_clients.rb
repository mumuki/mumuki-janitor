FactoryGirl.define do
  factory :api_client do
    description "foo"
    permissions { {student: 'foo/*'} }
  end
end
