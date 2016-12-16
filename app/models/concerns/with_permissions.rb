module WithPermissions
  extend ActiveSupport::Concern

  included do
    serialize :permissions, Mumukit::Auth::Permissions

    validates_presence_of :permissions

    def self.parse!(params)
      params.merge!(permissions: Mumukit::Auth::Permissions.load(params[:permissions]))
    end
  end
end