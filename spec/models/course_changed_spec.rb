require 'spec_helper'

describe Office::Event::CourseChanged do
  let(:course_json) do
    {slug: 'test/bar',
     uid: 'test/bar',
     shifts: %w(morning),
     code: 'k2003',
     days: %w(monday wednesday),
     period: '2016',
     description: 'test course',
     subscription_mode: 'closed'}
  end
  let(:course_data) {
    { course: course_json}
  }
  let!(:organization) { create :organization, name: 'test' }
  before { Office::Event::CourseChanged.execute! course_data }
  it {expect(Course.first.uid).to eq 'test/bar'}
  it {expect(Course.first.slug).to eq 'test/bar'}
  it {expect(Course.first.code).to eq 'k2003'}
  it {expect(Course.first.days).to eq %w(monday wednesday)}
  it {expect(Course.first.period).to eq '2016'}
end
