class CreateDevices < ActiveRecord::Migration[5.1]
  def change
    create_table :devices do |t|
      t.string :name
      t.string :sn
      t.string :model
      t.string :coordinate
      t.string :address
      t.string :floor
      t.string :power
      t.integer :powerstatu
      t.datetime :reportTime

      t.timestamps
    end
  end
end
