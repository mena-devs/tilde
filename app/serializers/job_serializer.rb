class JobSerializer
  include FastJsonapi::ObjectSerializer
  attributes :custom_identifier, :title, :description, :currency

  belongs_to :user

  attribute :salary do |object|
    exp_salary = "#{object.from_salary}"
    unless object.to_salary.blank?
      exp_salary += " - #{object.to_salary}"
    end
  end

  attribute :creator_name do |object|
    "#{object.user.name}"
  end
end
