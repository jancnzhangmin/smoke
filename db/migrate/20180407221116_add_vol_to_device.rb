class AddVolToDevice < ActiveRecord::Migration[5.1]
  def change
    add_column :devices, :vol, :float
  end
end
