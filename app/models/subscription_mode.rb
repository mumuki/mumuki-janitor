module SubscriptionMode
  SUBSCRIPTION_MODES = [Open, Closed]

  def self.load(index)
    SUBSCRIPTION_MODES[index || 0]
  end

  def self.dump(subscription_mode)
    coerce(subscription_mode).to_i
  end

  def self.from_sym(subscription_mode)
    "SubscriptionMode::#{subscription_mode.to_s.camelize}".constantize
  end

  def self.coerce(subscription_like)
    if subscription_like.is_a? Symbol or subscription_like.is_a? String
      from_sym(subscription_like)
    elsif subscription_like.is_a? SubscriptionMode::Base
      subscription_like
    else
      subscription_like.subscription_mode
    end
  end

end

