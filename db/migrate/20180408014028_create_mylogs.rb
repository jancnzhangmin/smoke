class CreateMylogs < ActiveRecord::Migration[5.1]
  def change
    create_table :mylogs do |t|
      t.text :log

      t.timestamps
    end
  end
end
