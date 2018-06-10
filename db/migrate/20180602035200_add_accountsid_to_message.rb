class AddAccountsidToMessage < ActiveRecord::Migration[5.1]
  def change
    add_column :messages, :accountsid, :string
    add_column :messages, :auth_token, :string
    add_column :messages, :appid, :string
    add_column :messages, :isdefault, :integer
    add_column :messages, :keyword, :string
    add_column :messages, :name, :string
  end
end
