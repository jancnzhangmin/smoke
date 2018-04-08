class AddImsiToDevice < ActiveRecord::Migration[5.1]
  def change
    add_column :devices, :imsi, :string
    add_column :devices, :swver, :string
    add_column :devices, :hwver, :string
  end
end
