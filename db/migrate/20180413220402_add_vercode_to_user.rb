class AddVercodeToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :vercode, :string
    add_column :users, :vertime, :datetime
  end
end
