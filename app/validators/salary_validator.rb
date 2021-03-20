class SalaryValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    record.errors.add(attribute.to_sym, (options[:message] || "cannot be less than starting salary")) unless valid_salary_fields?(record)
  end

  def valid_salary_fields?(record)
    return true if record.to_salary.blank?

    record.from_salary < record.to_salary
  end
end
