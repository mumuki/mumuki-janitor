module WithPermissions
  extend ActiveSupport::Concern

  included do
    serialize :permissions, Mumukit::Auth::Permissions

    validates_presence_of :permissions

    def self.parse!(params)
      params.merge!(permissions: Mumukit::Auth::Permissions.load(params[:permissions]))
    end

    def add_student_permission!(grant)
      add_permission! :student, grant
    end

    def update_permissions!(new_permissions)
      update! permissions: permissions.merge(Mumukit::Auth::Permissions.parse(new_permissions))
    end

    private

    def add_permission!(role, grant)
      permissions.add_permission! role, grant
    end

    def set_permissions!
      Mumukit::Auth::Store.set! uid, permissions
    end
  end
end