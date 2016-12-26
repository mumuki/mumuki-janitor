class ActiveRecord::Base
  def self.update_or_create(attributes)
    obj = first || new
    obj.tap { |o| o.assign_attributes(attributes) }
  end
end
