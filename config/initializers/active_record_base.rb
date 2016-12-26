class ActiveRecord::Base
  def self.update_or_create!(attributes)
    obj = first || new
    obj.update!(attributes)
    obj
  end
end
