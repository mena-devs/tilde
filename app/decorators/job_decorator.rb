class JobDecorator < ApplicationDecorator
  delegate_all

  # Define presentation-specific methods here. Helpers are accessed through
  # `helpers` (aka `h`). You can override attributes, for example:
  #
  #   def created_at
  #     helpers.content_tag :span, class: 'time' do
  #       object.created_at.strftime("%a %m/%d/%y")
  #     end
  #   end

  def salary_to_s
    return "" if object.from_salary.blank?

    if object.to_salary.blank? || object.from_salary == object.to_salary
      formatted_salary = ActionController::Base.helpers.number_to_currency(object.from_salary, precision: 0)
    else
      formatted_salary = ActionController::Base.helpers.number_to_currency(object.from_salary, precision: 0)
      formatted_salary += ' - '
      formatted_salary += ActionController::Base.helpers.number_to_currency(object.from_salary, precision: 0)
    end

    formatted_salary += '/per year'

    return formatted_salary
  end
end
