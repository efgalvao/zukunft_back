class CreateDividends < ActiveRecord::Migration[7.0]
  def change
    create_table :dividends do |t|
      t.datetime :date
      t.integer :value_cents, default: 0, null: false
      t.belongs_to :stock, null: false, foreign_key: true
      t.timestamps
    end
  end
end
