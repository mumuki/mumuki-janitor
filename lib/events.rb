Mumukit::Nuntius::EventConsumer.handle do
  event 'UserChanged' do |payload|
    User.import_from_json! payload[:user].except(:created_at, :updated_at)
  end

  event 'CourseChanged' do |payload|
    Course.import_from_json! payload[:course].except(:created_at, :updated_at)
  end
end