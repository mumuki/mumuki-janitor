FactoryGirl.define do
  factory :course do
    name "MyString"
    subscription_mode SubscriptionMode::Open
    organization_id 1
  end
end
