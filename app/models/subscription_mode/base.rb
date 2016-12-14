module SubscriptionMode::Base
  def to_s
    name.demodulize.underscore
  end

  def to_i
    SubscriptionMode::SUBSCRIPTION_MODES.index(self)
  end

  def to_sym
    to_s.to_sym
  end

  def as_json(_options={})
    to_s
  end
end
