class ActiveRecord::Base
  def self.update_or_create(attributes)
    obj = first || new
    obj.assign_attributes(attributes)
    obj
  end
end
