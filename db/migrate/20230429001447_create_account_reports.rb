class CreateAccountReports < ActiveRecord::Migration[7.0]
  def change
    create_table :account_reports do |t|
      t.references :account, null: false, foreign_key: true
      t.integer :incomes_cents, default: 0, null: false
      t.integer :expenses_cents, default: 0, null: false
      t.integer :invested_cents, default: 0, null: false
      t.integer :final_balance_cents, default: 0, null: false
      t.integer :dividends_cents, default: 0, null: false
      t.integer :total_balance_cents, default: 0, null: false
      t.date :date, null: false

      t.timestamps
    end
  end
end
