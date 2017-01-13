class AtLeastOneValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if value.length === 0
      record.errors.add "#{attribute}", (options[:message] || 'has no elements')
    end
  end
end