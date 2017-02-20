class Exchange < ActiveRecord::Migration
  def change
    create_table :exchanges do |t|
      t.string :currency
      t.date :date
      t.decimal :rate, precision: 15, scale: 5
      t.timestamps null: false
    end
    add_index :exchanges, [:currency, :date], :unique => true
  end
end
