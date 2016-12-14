class NotificationMode::Nuntius
  def notify!(exchange_name, event)
    Mumukit::Nuntius::Publisher.publish exchange_name, event
  end

  def notify_event!(event, data)
    Mumukit::Nuntius::EventPublisher.publish event, data
  end
end
