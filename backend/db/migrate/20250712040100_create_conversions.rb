class CreateConversions < ActiveRecord::Migration[5.2]
  def change
    create_table :conversions do |t|
      t.string :source_currency, null: false
      t.string :target_currency, null: false
      t.decimal :source_amount, precision: 16, scale: 4, null: false
      t.decimal :target_amount, precision: 16, scale: 4, null: false
      t.decimal :rate, precision: 16, scale: 8, null: false

      t.timestamps
    end
    
    add_index :conversions, :created_at
  end
end
