class ApiClient < ApplicationRecord

  include WithPermissions

  belongs_to :user

  before_create :set_token

  validates_presence_of :description

  accepts_nested_attributes_for :user

  private

  def set_token
    self.token = Mumukit::Auth::Token.generate_token
  end
end
