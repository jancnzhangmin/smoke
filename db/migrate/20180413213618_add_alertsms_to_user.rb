class AddAlertsmsToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :alertsms, :integer
    add_column :users, :alertwx, :integer
  end
end
