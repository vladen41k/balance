class CreateTransactions < ActiveRecord::Migration[6.1]
  def change
    create_table :transactions do |t|
      t.belongs_to :user, foreign_key: true, null: false
      t.integer :amount, null: false

      t.timestamps
    end
  end
end
