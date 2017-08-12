class EmailValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    record.errors[attribute] << (options[:message] || "must be a valid email address") unless email_valid?(value)
  end

  def email_valid?(email_address)
    return true if email_address.blank?

    email_address =~ /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
  end
end
