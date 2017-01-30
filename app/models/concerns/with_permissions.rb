module WithPermissions
  extend ActiveSupport::Concern

  included do
    serialize :permissions, Mumukit::Auth::Permissions

    validates_presence_of :permissions

    delegate :add_permission!,
             :remove_permission!,
             :has_permission?,
             :has_permission_delegation?,
             :protect!,
             :protect_delegation!, to: :permissions

    def self.parse!(params)
      params.merge!(permissions: Mumukit::Auth::Permissions.load(params[:permissions]))
    end

    def update_permissions!(new_permissions)
      update! permissions: permissions.merge(Mumukit::Auth::Permissions.parse(new_permissions))
    end

    private

    def set_permissions!
      Mumukit::Auth::Store.set! uid, permissions
    end
  end
end