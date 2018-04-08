class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :openid
      t.string :headurl
      t.string :phone
      t.integer :sex
      t.integer :status
      t.integer :up_id

      t.timestamps
    end
  end
end
