class SalaryValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    record.errors[attribute] << (options[:message] || "cannot be less than starting salary") unless valid_salary_fields?(record)
  end

  def valid_salary_fields?(record)
    (record.from_salary < record.to_salary) if !record.to_salary.blank?
  end
end
