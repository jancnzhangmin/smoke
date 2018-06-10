class CreateMytests < ActiveRecord::Migration[5.1]
  def change
    create_table :mytests do |t|
      t.string :test

      t.timestamps
    end
  end
end
