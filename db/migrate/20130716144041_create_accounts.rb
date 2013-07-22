class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.string :currency
      t.decimal :amount, precision: 12, scale: 4, null: false, default: 0
      t.decimal :reserved, precision: 12, scale: 4, null: false, default: 0
      t.references :user, index: true

      t.timestamps
    end
    execute "ALTER TABLE accounts ADD CONSTRAINT amount_check_positive CHECK (amount >= 0)"
  end
end
