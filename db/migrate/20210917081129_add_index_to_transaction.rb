class AddIndexToTransaction < ActiveRecord::Migration[6.1]
  def change
    add_index :transactions, [:user_id, :created_at]
  end
end
