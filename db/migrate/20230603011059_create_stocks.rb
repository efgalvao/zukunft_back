class CreateStocks < ActiveRecord::Migration[7.0]
  def change
    create_table :stocks do |t|
      t.string :ticker, null: false
      t.integer :invested_value_cents, default: 0, null: false
      t.integer :current_value_cents, default: 0, null: false
      t.integer :current_total_value_cents, default: 0, null: false
      t.integer :shares_total, default: 0
      t.belongs_to :account, null: false, foreign_key: true

      t.timestamps
    end
  end
end
