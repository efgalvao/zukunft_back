class CreateCategories < ActiveRecord::Migration[7.0]
  def change
    create_table :categories do |t|
      t.string :name, null: false, index: { unique: true }
      t.references :user, foreign_key: { to_table: :users }, null: false

      t.timestamps
    end
  end
end
