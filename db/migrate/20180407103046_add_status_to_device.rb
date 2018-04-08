class AddStatusToDevice < ActiveRecord::Migration[5.1]
  def change
    add_column :devices, :status, :integer
  end
end
