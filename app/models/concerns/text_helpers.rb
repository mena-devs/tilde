module TextHelpers
  include ActiveSupport::Concern

  def boolean_to_string(value)
    yes_values = [true, 1, "1"]
    no_values = [nil, false, 0, "0"]

    if yes_values.include?(value)
      return "Yes"
    elsif no_values.include?(value)
      return "No"
    end
  end
end