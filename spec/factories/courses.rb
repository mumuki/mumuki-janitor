FactoryGirl.define do
  factory :course do
    slug 'test/example'
    period '2016'
    code 'K2003'
    shifts %w(morning)
    days %w(monday wednesday)
    description 'test'
    organization_id 1
  end
end
