FactoryGirl.define do
  factory :api_client do
    name "foo"
    permissions { {student: 'foo/*'} }
  end
end
