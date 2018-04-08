class CreateDevicehistorylists < ActiveRecord::Migration[5.1]
  def change
    create_table :devicehistorylists do |t|
      t.string :sn
      t.string :imsi
      t.string :swver
      t.string :hwver
      t.float :vol
      t.integer :alarmstatus
      t.string :rsrp
      t.string :sinr
      t.string :wsc
      t.string :ctime
      t.float :vol2
      t.datetime :ctimestramp

      t.timestamps
    end
  end
end
