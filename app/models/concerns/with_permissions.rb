module WithPermissions
  extend ActiveSupport::Concern

  included do
    serialize :permissions, JSON
  end

end