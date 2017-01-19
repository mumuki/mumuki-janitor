class ApiClient < ApplicationRecord

  belongs_to :user

  before_create :set_token

  validates_presence_of :description

  delegate :permissions, to: :user
  delegate :has_permission?, :has_permission_delegation?, to: :permissions
  delegate :protect!, :protect_delegation!, to: :permissions

  accepts_nested_attributes_for :user

  private

  def set_token
    self.token = Mumukit::Auth::Token.encode user.uid, user.permissions
  end
end
