class User < ApplicationRecord

  serialize :permissions, JSON

  validates_presence_of :first_name, :last_name, :email

  def update_permissions!(data)
    update!(permissions: data)
  end

end
