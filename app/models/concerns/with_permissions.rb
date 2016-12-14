module WithPermissions
  extend ActiveSupport::Concern

  included do
    serialize :permissions, JSON

    def self.parse!(params)
      params.merge!(permissions: JSON.parse(params[:permissions]))
    end
  end
end