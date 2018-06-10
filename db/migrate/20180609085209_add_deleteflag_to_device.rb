class AddDeleteflagToDevice < ActiveRecord::Migration[5.1]
  def change
    add_column :devices, :deleteflag, :integer
  end
end
