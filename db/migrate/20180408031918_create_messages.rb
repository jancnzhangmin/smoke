class CreateMessages < ActiveRecord::Migration[5.1]
  def change
    create_table :messages do |t|
      t.string :appkey
      t.string :secret

      t.timestamps
    end
  end
end
