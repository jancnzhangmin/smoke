class AddCallbackurlToConfig < ActiveRecord::Migration[5.1]
  def change
    add_column :configs, :callbackurl, :string
  end
end
