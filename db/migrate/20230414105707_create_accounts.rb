class CreateAccounts < ActiveRecord::Migration[7.0]
  def change
    create_table :accounts do |t|
      t.string :name, null: false, index: { unique: true }
      t.boolean 'savings'
      t.references :user, foreign_key: { to_table: :users }, null: false
      t.integer 'balance_cents', default: 0, null: false
      t.integer 'kind', default: 0, null: false

      t.timestamps
    end
  end
end
