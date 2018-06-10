class CreateDevicelogs < ActiveRecord::Migration[5.1]
  def change
    create_table :devicelogs do |t|
      t.string :sn

      t.timestamps
    end
  end
end
