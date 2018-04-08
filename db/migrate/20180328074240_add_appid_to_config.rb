class AddAppidToConfig < ActiveRecord::Migration[5.1]
  def change
    add_column :configs, :appid, :string
    add_column :configs, :secret, :text
  end
end
