class ConvertSalaryColumnsToIntegers < ActiveRecord::Migration[5.0]
  def change
    change_column :jobs, :from_salary,
        'integer USING CAST(from_salary AS integer)'

    change_column :jobs, :to_salary,
        'integer USING CAST(to_salary AS integer)'
  end
end
