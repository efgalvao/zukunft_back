class CreateNegotiations < ActiveRecord::Migration[7.0]
  def change
    create_table :negotiations do |t|
      t.string :kind
      t.date :date
      t.integer :invested_cents, default: 0
      t.integer :shares, default: 0
      t.references :negotiable, polymorphic: true
      t.timestamps
    end
  end
end
