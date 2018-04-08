class CreateAccesstokens < ActiveRecord::Migration[5.1]
  def change
    create_table :accesstokens do |t|
      t.text :access_token
      t.datetime :exptime

      t.timestamps
    end
  end
end
