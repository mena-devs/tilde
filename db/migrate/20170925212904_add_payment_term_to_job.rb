class AddPaymentTermToJob < ActiveRecord::Migration[5.0]
  def change
    add_column :jobs, :payment_term, :integer
  end
end
