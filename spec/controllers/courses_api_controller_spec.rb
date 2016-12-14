require 'rails_helper'

describe Api::CoursesController, type: :controller do
  let(:course_json) do
    {slug: 'foo/bar',
     shifts: %w(morning),
     code: 'k2003',
     days: %w(monday wednesday),
     period: '2016',
     description: 'test course',
     subscription_mode: 'closed'}
  end

  let!(:organization) { create :organization, name: 'foo' }

  context 'post' do
    before { post :create, params: { course: course_json }}

    it { expect(response.status).to eq 200 }
    it { expect(Course.count).to eq 1 }
    it { expect(Course.first.uid).to eq 'foo/bar' }
    it { expect(Course.first.subscription_mode).to eq SubscriptionMode::Closed }
    it { expect(Course.first.organization).to eq(organization) }
    it { expect(Course.first.shifts).to eq(%w(morning)) }
    it { expect(Course.first.days).to eq(%w(monday wednesday)) }
  end

end
