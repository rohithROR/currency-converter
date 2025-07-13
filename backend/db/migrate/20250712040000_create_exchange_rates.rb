class CreateExchangeRates < ActiveRecord::Migration[5.2]
  def change
    create_table :exchange_rates do |t|
      t.string :source_currency, null: false
      t.string :target_currency, null: false
      t.decimal :rate, precision: 16, scale: 8, null: false
      t.datetime :expires_at, null: false

      t.timestamps
    end
    
    add_index :exchange_rates, [:source_currency, :target_currency]
  end
end
