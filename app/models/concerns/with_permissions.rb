module WithPermissions
  extend ActiveSupport::Concern

  included do
    include Mumukit::Login::UserPermissionsHelpers

    serialize :permissions, Mumukit::Auth::Permissions

    def self.parse!(params)
      params.merge!(permissions: Mumukit::Auth::Permissions.load(params[:permissions]))
    end
  end
end