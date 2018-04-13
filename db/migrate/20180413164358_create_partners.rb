class CreatePartners < ActiveRecord::Migration[5.0]
  def change
    create_table :partners do |t|
      t.string :name
      t.string :description
      t.string :external_link
      t.string :email
      t.boolean :active

      t.timestamps
    end
  end
end
