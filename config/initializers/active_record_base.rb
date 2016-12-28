class ActiveRecord::Base
  def self.assign_first(attributes)
    obj = first || new
    obj.tap { |o| o.assign_attributes(attributes) }
  end
end
