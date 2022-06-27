class EmailValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless (email_valid?(value) && handle_contains_number_of_dots(value) && handle_last_character_is_not_dot(value))
      record.errors[attribute] << email_invalid_error_message
    end
  end

  private

  def email_invalid_error_message
    # options[:message] || I18n.t('errors.messages.email')
    (options[:message] || 'must be a valid email address')
  end

  def email_valid?(email_address)
    return true if email_address.blank?

    email_address =~ /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
  end

  def handle_contains_number_of_dots(email_address)
    return true if email_address.blank?

    email_handle = email_address.split('@')
    email_handle[0].count('.') < 3 if email_handle && !email_handle.blank?
  end

  def handle_last_character_is_not_dot(email_address)
    return true if email_address.blank?

    email_handle = email_address.split('@')
    email_handle[0][-1] != '.' if email_handle && !email_handle.blank?
  end
end
