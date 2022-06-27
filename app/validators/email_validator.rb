class EmailValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless email_valid?(value)
      record.errors[attribute] << email_invalid_error_message
    end

    unless handle_contains_number_of_dots(value)
      record.errors[attribute] << email_contains_dots_error_message
    end

    unless handle_last_character_is_not_dot(value)
      record.errors[attribute] << email_ends_with_dot_error_message
    end
  end

  private
    def email_invalid_error_message
      # options[:message] || I18n.t('errors.messages.email')
      (options[:message] || "must be a valid email address")
    end

    def email_contains_dots_error_message
      (options[:message] || "must contain fewer dots")
    end

    def email_ends_with_dot_error_message
      (options[:message] || "must not end with a dot")
    end

    def email_valid?(email_address)
      return true if email_address.blank?

      email_address =~ /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
    end

    def handle_contains_number_of_dots(email_address)
      return true if email_address.blank?

      email_handle = email_address.split('@')

      if (email_handle && !email_handle.blank?)
        email_handle[0].count('.') < 3
      end
    end

    def handle_last_character_is_not_dot(email_address)
      return true if email_address.blank?

      email_handle = email_address.split('@')

      if (email_handle && !email_handle.blank?)
        email_handle[0][-1] != "."
      end
    end
end