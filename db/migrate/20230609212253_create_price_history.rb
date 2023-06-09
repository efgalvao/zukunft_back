class CreatePriceHistory < ActiveRecord::Migration[7.0]
  def change
    create_table :prices do |t|
      t.date :date
      t.integer :value_cents, default: 0
      t.references :priceable, polymorphic: true
      t.timestamps
    end
  end
end
