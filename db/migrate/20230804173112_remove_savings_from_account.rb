class RemoveSavingsFromAccount < ActiveRecord::Migration[7.0]
  def change
    remove_column :accounts, :savings
  end
end
