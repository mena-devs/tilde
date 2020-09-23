module TextHelpers
  include ActiveSupport::Concern

  def boolean_to_string(value)
    return "No" if value.nil?

    if (value == true || value == 1 || value == "1")
      "Yes"
    elsif (value == false || value == 0 || value == "0")
      "No"
    end
  end
end