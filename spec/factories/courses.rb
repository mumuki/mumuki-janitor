FactoryGirl.define do
  factory :course do
    slug 'academy/example'
    period '2016'
    code 'K2003'
    shifts %w(morning)
    days %w(monday wednesday)
    description 'test'
    subscription_mode SubscriptionMode::Open
    organization_id 1
  end
end
