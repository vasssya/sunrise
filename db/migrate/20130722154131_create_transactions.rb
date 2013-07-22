class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.references :from, index: true
      t.references :to, index: true
      t.integer :bids, array: true
      t.integer :amount

      t.timestamps
    end
  end
end
