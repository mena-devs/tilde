class AddAvailabilityAndInterestToProfile < ActiveRecord::Migration[5.0]
  def change
    add_column :profiles, :interests, :string
  end
end
