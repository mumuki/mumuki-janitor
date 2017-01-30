module WithSubscriptionMode

  extend ActiveSupport::Concern

  included do
    serialize :subscription_mode, SubscriptionMode
    validates_presence_of :subscription_mode
  end

end
