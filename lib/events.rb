Mumukit::Nuntius::EventConsumer.handle do
  event 'UserChanged' do |payload|
    User.import_from_json! payload[:user]
  end

  event 'CourseChanged' do |payload|
    Course.import_from_json! payload[:course]
  end
end