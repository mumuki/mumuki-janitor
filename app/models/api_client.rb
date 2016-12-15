class ApiClient < ApplicationRecord

  belongs_to :user

  before_create :set_token

  validates_presence_of :description

  accepts_nested_attributes_for :user

  private

  def set_token
    self.token = Mumukit::Auth::Token.encode user.permissions
  end
end
